//
//  APIAppState.swift
//  MySchoolAssistant
//
//  Created by EdwImac03 on 2023-04-06.
//
import Combine
import Foundation

class APIAppState: ObservableObject {
    @Published var brokerAdress: String = ""
    @Published var identifierName: String = ""
    @Published var userValideState: Bool = false
    
    func setBrokerAdress(address: String) {
        brokerAdress = address
    }
    
    func setIdentifierName(name: String) {
        identifierName = name
    }
    
    func setUserValideState(state: Bool) {
        userValideState = state
    }
}
