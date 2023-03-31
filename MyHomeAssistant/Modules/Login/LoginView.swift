//
//  LoginView.swift
//  MySchoolAssistant
//
//  Created by EdwImac03 on 2023-03-31.
//

import SwiftUI

struct LoginView: View {
    @State var userName: String = ""
    @State var password: String = ""
    @State var alerte: String = ""
    @State var isHiddenState: Bool = true
    @EnvironmentObject private var mqttManager: MQTTManager
    @EnvironmentObject private var userConnexionStatus: APIManager
    var body: some View {
        VStack {
            MQTTTextField(placeHolderMessage: "Enter user name", isDisabled: mqttManager.currentAppState.appConnectionState != .disconnected, message: $userName)
                .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            MQTTTextField(placeHolderMessage: "Enter password", isDisabled: mqttManager.currentAppState.appConnectionState != .disconnected, message: $password)
                .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            HStack(spacing: 50) {
                setUpConnectButton()
                setUpDisconnectButton()
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Configure / enable /disable connect button
    private func setUpConnectButton() -> some View  {
        return Button(action: { validateUser() }) {
                Text("Connect")
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .blue))
            .disabled(mqttManager.currentAppState.appConnectionState != .disconnected || userName.isEmpty || password.isEmpty)
    }
    
    private func setUpDisconnectButton() -> some View  {
        return Button(action: { disconnect() }) {
            Text("Disconnect")
        }.buttonStyle(BaseButtonStyle(foreground: .white, background: .red))
        .disabled(mqttManager.currentAppState.appConnectionState == .disconnected)
    }
    private func validateUser() {
        userConnexionStatus.getUsersRequest(usager: userName, motDePasse: password)
        configureAndConnect()
    }
    
    private func configureAndConnect() {
        // Initialize the MQTT Manager
        if(userConnexionStatus.userValideState == true){
            mqttManager.initializeMQTT(host: userConnexionStatus.brokerAdress, identifier: UUID().uuidString)
            // Connect
            mqttManager.connect()
            isHiddenState = true
        }else{
            showAlert()
        }
    }

    private func disconnect() {
        mqttManager.disconnect()
    }
    
    func showAlert() {
        isHiddenState = false
        alerte = "Invalid user or password"
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
