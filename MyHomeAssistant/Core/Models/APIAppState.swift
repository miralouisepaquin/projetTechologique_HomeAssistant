//
//  APIAppState.swift
//  MySchoolAssistant
//
//  Created by Mira Paquin on 2023-04-06.
//
import Combine
import Foundation

class APIAppState: ObservableObject {
    @Published var identifierName: String = ""
    @Published var userCode: Int = 0
    @Published var userValideState: Bool = false
    
    
    func setUserCode(code: Int) {
        userCode = code
    }
    
    func setIdentifierName(name: String) {
        identifierName = name
    }
    
    func setUserValideState(state: Bool) {
        userValideState = state
    }
}
