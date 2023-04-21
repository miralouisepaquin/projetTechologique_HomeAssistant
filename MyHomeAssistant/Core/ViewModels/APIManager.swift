//
//  APIManager.swift
//  MyHomeAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//

import Combine
import Foundation

final class APIManager: ObservableObject {
    @Published var currentAPIstate = APIAppState()
    @Published var currentSensorState = SensorAppState()
    
    func getUsersRequest(usager: String, motDePasse: String) {
        let usager = usager
        let motDePasse = motDePasse
        
        struct Users: Codable {
            let mail: String
            let password: String
            let code: Int
            let broker: String
        }
        
        // Prepare URL
        let urlString = "http://51.222.158.139:3001/api/users/findAllUsers"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
                    
            guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let data = data else {
                print("Invalid response")
                return
            }
                    
            do {
                let people = try JSONDecoder().decode([Users].self, from: data)
                // Access the single Person object in the array
                people.forEach { user in
                    if(usager == user.mail && motDePasse == String(user.password)){
                        currentAPIstate.setBrokerAdress(address: user.broker)
                        currentAPIstate.setIdentifierName(name: user.mail)
                        currentAPIstate.setUserCode(code: user.code)
                        currentAPIstate.setUserValideState(state: true)
                    }
                }
                if(currentAPIstate.userValideState != true){
                    currentAPIstate.setUserValideState(state: false)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func getSensorsRequest() {
        
        struct Sensors: Codable {
            let name: String
            let friendlyName: String
            let room: String
        }
        
        // Prepare URL
        let urlString = "http://51.222.158.139:3001/api/sensors/findAllSensors"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
                    
            guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let data = data else {
                print("Invalid response")
                return
            }
                    
            do {
                let sensors = try JSONDecoder().decode([Sensors].self, from: data)
                sensors.forEach { sensor in
                    currentSensorState.setsensorList(items: [sensor.friendlyName])
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
}


//GET, POST, PUT, DELETE, etc...
func postLogsRequest(text: String) {
    // Create Date
    let date = Date()
    // Create Date Formatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    // Prepare URL
    let url = URL(string: "http://51.222.158.139:3001/api/logs/createLog")
    guard let requestUrl = url else {
        print("Invalid URL")
        return }
    // Methode, body, header
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: AnyHashable] = [
        "date":  dateFormatter.string(from: date),
        "description": text
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            print("guard error")
            return
        }
        do{
            let response = try JSONDecoder().decode(Logs.self, from: data)
            print("Success: \(response)")
        }
        catch {
            print(error)
        }
    }
    task.resume()
    
    struct Logs: Codable{
        let date: String
        let description: String
    }
}
