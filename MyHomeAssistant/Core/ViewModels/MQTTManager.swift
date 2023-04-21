//
//  MQTTManager.swift
//  MyHomeAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//

import Foundation
import CocoaMQTT
import Combine

final class MQTTManager: ObservableObject {
    private var mqttClient: CocoaMQTT?
    private var identifier: String!
    private var host: String!
    private var topic: String!
    private var username: String!
    private var password: String!

    @Published var currentAppState = MQTTAppState()
    @Published var currentAPIState = APIAppState()
    @Published var currentSensorState = SensorAppState()
    private var anyCancellable: AnyCancellable?
    private var anyCancellable2: AnyCancellable?
    // Private Init
    public init() {
        // Workaround to support nested Observables, without this code changes to state is not propagated
        anyCancellable = currentAppState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        anyCancellable2 = currentSensorState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    // MARK: Shared Instance

    private static let _shared = MQTTManager()

    // MARK: - Accessors

    class func shared() -> MQTTManager {
        return _shared
    }

    func initializeMQTT(host: String, identifier: String, username: String? = nil, password: String? = nil) {
        // If any previous instance exists then clean it
        if mqttClient != nil {
            mqttClient = nil
        }
        self.identifier = identifier
        self.host = host
        self.username = username
        self.password = password

        // TODO: Guard
        mqttClient = CocoaMQTT(clientID: identifier, host: host, port: 1883)
        // If a server has username and password, pass it here
        if let finalusername = self.username, let finalpassword = self.password {
            mqttClient?.username = finalusername
            mqttClient?.password = finalpassword
        }
        mqttClient?.keepAlive = 60
        mqttClient?.delegate = self
    }

    func connect() {
        if let success = mqttClient?.connect(), success {
            currentAppState.setAppConnectionState(state: .connecting)
        } else {
            currentAppState.setAppConnectionState(state: .disconnected)
        }
    }

    func subscribe(topic: String) {
        self.topic = topic
        mqttClient?.subscribe(topic, qos: .qos1)
    }

    func publish(with message: String) {
        mqttClient?.publish(topic, withString: message, qos: .qos1)
    }

    func disconnect() {
        mqttClient?.disconnect()
    }

    /// Unsubscribe from a topic
    func unSubscribe(topic: String) {
        mqttClient?.unsubscribe(topic)
    }

    /// Unsubscribe from a topic
    func unSubscribeFromCurrentTopic() {
        mqttClient?.unsubscribe(topic)
    }
    
    func currentHost() -> String? {
        return host
    }
    
    func isSubscribed() -> Bool {
       return currentAppState.appConnectionState.isSubscribed
    }
    
    func isConnected() -> Bool {
        return currentAppState.appConnectionState.isConnected
    }
    
    func connectionStateMessage() -> String {
        return currentAppState.appConnectionState.description
    }
}

extension MQTTManager: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        TRACE("trust: \(trust)")
        completionHandler(true)
    }

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        TRACE("ack: \(ack)")

        if ack == .accept {
            currentAppState.setAppConnectionState(state: .connected)
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        TRACE("new state: \(state)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string.description), id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        TRACE("id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string.description), id: \(id)")
        filtreMessage(message: message.string.description)
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        TRACE("subscribed: \(success), failed: \(failed)")
        currentAppState.setAppConnectionState(state: .connectedSubscribed)
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        TRACE("topic: \(topics)")
        currentAppState.setAppConnectionState(state: .connectedUnSubscribed)
        currentAppState.clearData()
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        TRACE()
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        TRACE()
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        TRACE("\(err.description)")
        currentAppState.setAppConnectionState(state: .disconnected)
    }
}

extension MQTTManager {
    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 1 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }

        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconect"
        }

        print("[TRACE] [\(prettyName)]: \(message)")
    }
    
    func filtreMessage(message: String){
        var publishedOnce = false
        var messagefiltre1 = ""
        var messagefiltrer = ""
        if(message.first == "{"){
            messagefiltre1  = String(message.dropFirst())
        }
        if(message.last == "}"){
            messagefiltrer = String(messagefiltre1.dropLast())
        }
        
        let objects = messagefiltrer.components(separatedBy: ",")
        
        objects.forEach { object in
            let invalidCharacters = CharacterSet(charactersIn: "\"")
            let attributs = object.components(separatedBy: ":")
            
            var sujet: String
            var valeur: String
            if attributs.count == 1 {
                sujet = ""
                valeur = attributs[0]
                if( valeur.first.description.rangeOfCharacter(from: invalidCharacters) != nil){
                    valeur  = String(valeur.dropFirst())
                }
                if(valeur.last.description.rangeOfCharacter(from: invalidCharacters) != nil){
                    valeur = String(valeur.dropLast())
                }
            }else{
                if(attributs.count == 2){
                    sujet = attributs[0]
                    if( sujet.first.description.rangeOfCharacter(from: invalidCharacters) != nil){
                        sujet  = String(sujet.dropFirst())
                    }
                    if(sujet.last.description.rangeOfCharacter(from: invalidCharacters) != nil){
                        sujet = String(sujet.dropLast())
                    }
                    valeur = attributs[1]
                    if( valeur.first.description.rangeOfCharacter(from: invalidCharacters) != nil){
                        valeur  = String(valeur.dropFirst())
                    }
                    if(valeur.last.description.rangeOfCharacter(from: invalidCharacters) != nil){
                        valeur = String(valeur.dropLast())
                    }
                }else {
                    sujet = attributs[0]
                    if( sujet.first.description.rangeOfCharacter(from: invalidCharacters) != nil){
                        sujet  = String(sujet.dropFirst())
                    }
                    if(sujet.last.description.rangeOfCharacter(from: invalidCharacters) != nil){
                        sujet = String(sujet.dropLast())
                    }
                    valeur = attributs[1]+attributs[2]
                    if( valeur.first.description.rangeOfCharacter(from: invalidCharacters) != nil){
                        valeur  = String(valeur.dropFirst())
                    }
                    if(valeur.last.description.rangeOfCharacter(from: invalidCharacters) != nil){
                        valeur = String(valeur.dropLast())
                    }
                }
                if((sujet == "message" && valeur == "MQTT publish topic 'zigbee2mqtt/mira/door/contact'") && message.contains("true")){
                    currentAppState.setReceivedMessage(text: message)
                    currentSensorState.setsensorName(name: "mira/door")
                    currentSensorState.setSensorConnectionState(state: .detected)
                    postLogsRequest(text: message)
                    if(publishedOnce != true){
                        mqttClient?.publish("zigbee2mqtt", withString: "askCode01", qos: .qos1)
                        publishedOnce = true
                    }
                }
                if((sujet == "message" && valeur == "MQTT publish topic 'zigbee2mqtt/mira/motion/occupancy'") && message.contains("true")){
                    currentAppState.setReceivedMessage(text: message)
                    currentSensorState.setsensorName(name: "mira/motion")
                    currentSensorState.setSensorConnectionState(state: .detected)
                    postLogsRequest(text: message)
                    if(publishedOnce != true){
                        mqttClient?.publish("zigbee2mqtt", withString: "askCode01", qos: .qos1)
                        publishedOnce = true
                    }
                }
                if((sujet == "message" && valeur == "MQTT publish topic 'zigbee2mqtt/mira/button/action'") && message.contains("single")){
                    currentAppState.setReceivedMessage(text: message)
                    currentSensorState.setsensorName(name: "mira/button")
                    currentSensorState.setSensorConnectionState(state: .detected)
                    postLogsRequest(text: message)
                    if(publishedOnce != true){
                        mqttClient?.publish("zigbee2mqtt", withString: "askCode01", qos: .qos1)
                        publishedOnce = true
                    }
                }
                if(message.contains("zigbee2mqtt/code01") && message.contains(String(currentAPIState.userCode))){
                    currentSensorState.setSensorConnectionState(state: .undetected)
                    postLogsRequest(text: message)
                    if(publishedOnce == true){
                        publishedOnce = false
                    }
                }
            }
        }
    }
    
}


extension Optional {
    // Unwrap optional value for printing log only
    var description: String {
        if let wraped = self {
            return "\(wraped)"
        }
        return ""
    }
}
