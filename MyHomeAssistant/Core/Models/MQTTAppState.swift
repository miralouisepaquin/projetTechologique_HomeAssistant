//
//  MQTTAppStates.swift
//  MySchoolAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//

import Combine
import Foundation
let langStr = Locale.preferredLanguages[0]

enum MQTTAppConnectionState {
    case connected
    case disconnected
    case connecting
    case connectedSubscribed
    case connectedUnSubscribed

    var description: String {
        if langStr == "en" {
            switch self {
            case .connected:
                return "Connected"
            case .disconnected:
                return "Disconnected"
            case .connecting:
                return "Connecting"
            case .connectedSubscribed:
                return "Subscribed"
            case .connectedUnSubscribed:
                return "Connected Unsubscribed"
            }
            
        } else {
            switch self {
            case .connected:
                return "Connecté"
            case .disconnected:
                return "Déconnecté"
            case .connecting:
                return "En Connexion"
            case .connectedSubscribed:
                return "Inscrit"
            case .connectedUnSubscribed:
                return "Connecter Non Inscrit"
            }
        }
        
        
        
    }
    var isConnected: Bool {
        switch self {
        case .connected, .connectedSubscribed, .connectedUnSubscribed:
            return true
        case .disconnected,.connecting:
            return false
        }
    }
    
    var isSubscribed: Bool {
        switch self {
        case .connectedSubscribed:
            return true
        case .disconnected,.connecting, .connected,.connectedUnSubscribed:
            return false
        }
    }
}

final class MQTTAppState: ObservableObject {
    @Published var appConnectionState: MQTTAppConnectionState = .disconnected

    func setAppConnectionState(state: MQTTAppConnectionState) {
        appConnectionState = state
    }
}
