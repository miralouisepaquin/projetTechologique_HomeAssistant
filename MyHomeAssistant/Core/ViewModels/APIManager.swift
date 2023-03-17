//
//  APIManager.swift
//  MyHomeAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//

import SwiftUI

// Create Date
let date = Date()

// Create Date Formatter
let dateFormatter = DateFormatter()

//GET, POST, PUT, DELETE, etc...
func postLogsRequest(text: String) {
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    // Prepare URL
    let url = URL(string: "http://51.222.158.139:3001/api/logs")
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

func getUsersRequest() {
    
    struct Users: Codable {
        let mail: String
        let password: String
        let code: Int
    }
    
    // Prepare URL
    let urlString = "http://51.222.158.139:3001/api/users"
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
            let user = people[0]
            print(user)
            print("Mail: \(user.mail) , Password: \(user.password) , Code: \(user.code)")
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    task.resume()
}
