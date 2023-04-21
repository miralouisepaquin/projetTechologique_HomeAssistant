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
    @State var topic: String = ""
    @State var message: String = ""
    @EnvironmentObject private var mqttManager: MQTTManager
    @StateObject private var apiManager = APIManager()
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateMessage(), isConnected: mqttManager.isConnected())
            VStack {
                HStack {
                    MQTTTextField(placeHolderMessage: "Enter a topic to subscribe", isDisabled: !mqttManager.isConnected() || mqttManager.isSubscribed(), message: $topic)
                    Button(action: functionFor(state: mqttManager.currentAppState.appConnectionState)) {
                        Text(titleForSubscribButtonFrom(state: mqttManager.currentAppState.appConnectionState))
                            .font(.system(size: 14.0))
                    }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                        .frame(width: 100)
                        .disabled(!mqttManager.isConnected() || topic.isEmpty)
                }.padding(.bottom, 30)
                VStack {
                    ForEach(apiManager.currentSensorState.listItems, id:\.self){ sensor in
                        AlarmContainer(sensor: sensor, isDetected: mqttManager.currentSensorState.sensorConnectionState.isDetected && sensor == mqttManager.currentSensorState.sensorName)
                    }
                }
            }.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))

            Spacer()
        }
        .navigationTitle("Alarm")
        .navigationBarItems(trailing: NavigationLink(
            destination: SettingsView(brokerAddress: mqttManager.currentHost() ?? ""),
            label: {
                Image(systemName: "gear")
            }))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            apiManager.currentSensorState.clearSensorList()
            apiManager.getSensorsRequest()
        }
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
            return "Subscribe"
        case .connectedSubscribed:
            return "Unsubscribe"
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
