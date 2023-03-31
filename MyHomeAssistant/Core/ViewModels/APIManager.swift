//
//  APIManager.swift
//  MyHomeAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//

import SwiftUI
import Combine
import Foundation

public class APIManager: ObservableObject {
    @Published var brokerAdress: String = ""
    @Published var identifierName: String = ""
    @Published var userValideState: Bool = false
    
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
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
                    //print("Mail: \(user.mail) , Password: \(user.password) , Code: \(user.code)")
                    if(usager == user.mail && motDePasse == String(user.password)){
                        self.brokerAdress = user.broker
                        self.identifierName = user.mail
                        self.userValideState = true
                        
                        print("connexion user réussi")
                    }
                }
                if(self.userValideState != true){
                    print("Usager ou mot de passe non valide.")
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
