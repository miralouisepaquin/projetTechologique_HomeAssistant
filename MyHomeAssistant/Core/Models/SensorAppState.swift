//
//  AlarmAppState.swift
//  MySchoolAssistant
//
//  Created by Mira Paquin on 2023-04-20.
//

import Combine
import Foundation

enum SensorAppConnectionState {
    case detected
    case undetected
    
    var isDetected: Bool {
        switch self {
        case .detected:
            return true
        case .undetected:
            return false
        }
    }    
}

class SensorAppState: ObservableObject {
    @Published var sensorConnectionState: SensorAppConnectionState = .undetected
    @Published var sensorName: String = ""
    @Published var sensorRoom: String = ""
    @Published var listItems: [String] = []
    
    func setsensorName(name: String) {
        sensorName = name
    }
    
    func setsensorRoom(room: String) {
        sensorRoom = room
    }
    
    func setsensorList(items: [String]) {
        listItems = listItems + items
    }
    
    func clearSensorList() {
        listItems = []
    }
    
    func setSensorConnectionState(state: SensorAppConnectionState) {
        sensorConnectionState = state
    }
}
