//
//  AlarmsView.swift
//  MySchoolAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//
import SwiftUI

struct AlarmsView: View {
    // TODO: Remove singleton
    @StateObject var mqttManager = MQTTManager.shared()
    var body: some View {
        NavigationView {
            AlarmView()
        }
        .environmentObject(mqttManager)
    }
}

struct AlarmsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmsView()
    }
}

struct AlarmView: View {
    @EnvironmentObject private var mqttManager: MQTTManager
    @EnvironmentObject private var apiManager: APIManager
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateMessage(), isConnected: mqttManager.isConnected())
            VStack {
                VStack {
                    ForEach(apiManager.currentSensorState.listItems, id:\.self){ sensor in
                        AlarmContainer(sensor: sensor, isDetected: mqttManager.currentSensorState.sensorConnectionState.isDetected && sensor == mqttManager.currentSensorState.sensorName)
                    }
                }
            }.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))

            Spacer()
        }
        .navigationTitle("Alarm".localized)
        .navigationBarItems(trailing: NavigationLink(
            destination: SettingsView(brokerAddress: mqttManager.currentHost() ?? "",topic: mqttManager.currentTopic() ?? ""),
            label: {
                Image(systemName: "gear")
            }))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            apiManager.currentSensorState.clearSensorList()
            apiManager.getSensorsRequest()
            UserDefaults.standard.string(forKey: "local")
            UserDefaults.standard.synchronize()
        }
    }
}
