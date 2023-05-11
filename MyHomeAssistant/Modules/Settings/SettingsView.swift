//
//  SettingsView.swift
//  MySchoolAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//
import SwiftUI
import UIKit

extension String {

    var localized: String {
        let lang = currentLanguage()
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    //Remove here and add these in utilities class
    func saveLanguage(_ lang: String) {
        UserDefaults.standard.set(lang, forKey: "Locale")
        UserDefaults.standard.synchronize()
    }

    func currentLanguage() -> String {
        return (Language.ID(rawValue: UserDefaults.standard.string(forKey: "Locale") ?? "en") ?? Language.en).rawValue
    }
}

enum Language: String, CaseIterable, Identifiable {
    case en, fr
    var id: Self { self }
}

struct SettingsView: View {
    @State var selectedLanguage = Language.en
    @State var brokerAddress: String = ""
    @State var topic: String = ""
    @State var message: String = ""
    @EnvironmentObject var mqttManager: MQTTManager
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateMessage().localized, isConnected: mqttManager.isConnected())
            MQTTTextField(placeHolderMessage: "Enter broker Address".localized, isDisabled: mqttManager.currentAppState.appConnectionState != .disconnected, message: $brokerAddress)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))

            HStack(spacing: 50) {
                setUpConnectButton()
                setUpDisconnectButton()
            }
            HStack {
                MQTTTextField(placeHolderMessage: "Enter a topic to subscribe".localized, isDisabled: !mqttManager.isConnected() || mqttManager.isSubscribed(), message: $topic)

                setUpSubscribeButton()
            }.padding(.bottom, 30)
            .padding()
            HStack{
                List {
                    Picker("Language".localized, selection: $selectedLanguage) {
                        Text("English").tag(Language.en)
                        Text("Français").tag(Language.fr)
                    }.onChange(of: selectedLanguage) { newValue in
                        UserDefaults.standard.removeObject(forKey: "Locale")
                        mqttManager.currentLanguageState.setAppLanguage(language: "\(newValue)")
                        UserDefaults.standard.set("\(newValue)", forKey: "Locale")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("Settings".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedLanguage = Language.ID(rawValue: UserDefaults.standard.string(forKey: "Locale") ?? "en") ?? Language.en
        }
    }

    // Configure / enable /disable connect button
    private func setUpConnectButton() -> some View  {
        return Button(action: { configureAndConnect() }) {
            Text("Connect".localized)
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .blue))
        .disabled(mqttManager.currentAppState.appConnectionState != .disconnected || brokerAddress.isEmpty)
    }
    
    private func setUpDisconnectButton() -> some View  {
        return Button(action: { disconnect() }) {
            Text("Disconnect".localized)
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
            switch state {
            case .connected, .connectedUnSubscribed, .disconnected, .connecting:
                return "Subscribe".localized
            case .connectedSubscribed:
                return "Unsubscribe".localized
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
