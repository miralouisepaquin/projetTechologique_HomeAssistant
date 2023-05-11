//
//  MQTTAppStates.swift
//  MySchoolAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//

import Combine
import Foundation

enum MQTTAppConnectionState {
    case connected
    case disconnected
    case connecting
    case connectedSubscribed
    case connectedUnSubscribed

    var description: String {
        switch self {
        case .connected:
            return "Connected".localized
        case .disconnected:
            return "Disconnected".localized
        case .connecting:
            return "Connecting".localized
        case .connectedSubscribed:
            return "Subscribed".localized
        case .connectedUnSubscribed:
            return "Connected Unsubscribed".localized
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
