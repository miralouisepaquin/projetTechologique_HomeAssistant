//
//  LoginView.swift
//  MySchoolAssistant
//
//  Created by EdwImac03 on 2023-03-31.

import SwiftUI

struct LoginView: View {
    
    @State var userName = ""
    @State var password = ""
    @State var isAuthenticated: Bool = false
    @State var isHidden: Bool = true
    @State private var showMainView = false
    @EnvironmentObject var apiManager: APIManager
    @StateObject var mqttManager = MQTTManager.shared()
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("My School Assistant")
                    .font(.largeTitle)
                Spacer()
            }
            VStack {
                if(isHidden == false){
                    Text("Email ou mot de passe invalide!")
                }
                TextField("Enter user name", text: $userName)
                    .padding(EdgeInsets(top: 0.0, leading: 50, bottom: 0.0, trailing: 50))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Enter password", text: $password)
                    .padding(EdgeInsets(top: 0.0, leading: 50, bottom: 0.0, trailing: 50))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack(spacing: 50) {
                    Button("LogIn" ,action: {
                        getUsers()
                    })
                    .navigationDestination(isPresented: $isAuthenticated) {
                            AlarmView()
                    }
                }
                .padding()
                .background(Color(red: 0, green: 0, blue: 0.5))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()
                Spacer()
            }
            .padding(.bottom, 300)
            .navigationTitle("LogIn")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func getUsers(){
        apiManager.getUsersRequest(usager: userName, motDePasse: password)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            validateUser()
        })
    }
    
    private func validateUser() {        
        if(apiManager.currentAPIstate.userValideState == true){
            isAuthenticated = true
        }
        else{
            isHidden = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
