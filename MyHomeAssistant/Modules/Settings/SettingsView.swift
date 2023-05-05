//
//  SettingsView.swift
//  MySchoolAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//
import SwiftUI

struct SettingsView: View {
    let langStr = Locale.preferredLanguages[0]
    @State var brokerAddress: String = ""
    @State var topic: String = ""
    @State var message: String = ""
    @EnvironmentObject private var mqttManager: MQTTManager
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateMessage(), isConnected: mqttManager.isConnected())
            if langStr == "en"{
                MQTTTextField(placeHolderMessage: "Enter broker Address", isDisabled: mqttManager.currentAppState.appConnectionState != .disconnected, message: $brokerAddress)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            }else{
                MQTTTextField(placeHolderMessage: "Entrez l'adresse du broker", isDisabled: mqttManager.currentAppState.appConnectionState != .disconnected, message: $brokerAddress)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            }
            HStack(spacing: 50) {
                setUpConnectButton()
                setUpDisconnectButton()
            }
            HStack {
                if langStr == "en"{
                    MQTTTextField(placeHolderMessage: "Enter a topic to subscribe", isDisabled: !mqttManager.isConnected() || mqttManager.isSubscribed(), message: $topic)
                }else{
                    MQTTTextField(placeHolderMessage: "Entrez votre Topic", isDisabled: !mqttManager.isConnected() || mqttManager.isSubscribed(), message: $topic)
                }
                setUpSubscribeButton()
            }.padding(.bottom, 30)
            .padding()
            Spacer()
            HStack {
                
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Configure / enable /disable connect button
    private func setUpConnectButton() -> some View  {
        return Button(action: { configureAndConnect() }) {
                Text("Connect")
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .blue))
        .disabled(mqttManager.currentAppState.appConnectionState != .disconnected || brokerAddress.isEmpty)
    }
    
    private func setUpDisconnectButton() -> some View  {
        return Button(action: { disconnect() }) {
            Text("Disconnect")
        }.buttonStyle(BaseButtonStyle(foreground: .white, background: .red))
        .disabled(mqttManager.currentAppState.appConnectionState == .disconnected)
    }
    
    private func setUpSubscribeButton() -> some View  {
        return Button(action: functionFor(state: mqttManager.currentAppState.appConnectionState)) {
            Text(titleForSubscribButtonFrom(state: mqttManager.currentAppState.appConnectionState))
                .font(.system(size: 14.0))
        }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
            .frame(width: 100)
            .disabled(!mqttManager.isConnected() || topic.isEmpty)
    }
    
    private func configureAndConnect() {
        // Initialize the MQTT Manager
        mqttManager.initializeMQTT(host: brokerAddress, identifier: UUID().uuidString)
        // Connect
        mqttManager.connect()
    }

    private func disconnect() {
        mqttManager.disconnect()
    }
    
    private func subscribe(topic: String) {
        mqttManager.subscribe(topic: topic)
    }

    private func usubscribe() {
        mqttManager.unSubscribeFromCurrentTopic()
    }
    
    private func titleForSubscribButtonFrom(state: MQTTAppConnectionState) -> String {
        if langStr == "en"{
            switch state {
            case .connected, .connectedUnSubscribed, .disconnected, .connecting:
                return "Subscribe"
            case .connectedSubscribed:
                return "Unsubscribe"
            }
        }else{
            switch state {
            case .connected, .connectedUnSubscribed, .disconnected, .connecting:
                return "Connexion"
            case .connectedSubscribed:
                return "Déconnexion"
            }
        }
    }

    private func functionFor(state: MQTTAppConnectionState) -> () -> Void {
        switch state {
        case .connected, .connectedUnSubscribed, .disconnected, .connecting:
            return { subscribe(topic: topic) }
        case .connectedSubscribed:
            return { usubscribe() }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
