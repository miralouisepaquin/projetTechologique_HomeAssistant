//
//  LoginView.swift
//  MySchoolAssistant
//
//  Created by EdwImac03 on 2023-03-31.
//

import SwiftUI

struct LoginView: View {
    
    @State var userName = ""
    @State var password = ""
    @State var alerte = ""
    @State var isHidden = true
    @EnvironmentObject var apiManager: APIManager
    
    var body: some View {
        VStack {
            Label("My School Assistant", systemImage: "")
                .font(.largeTitle)
            Spacer()
        }
        VStack {
            if(isHidden != true){
                Label(alerte, systemImage: "")
            }
            TextField("Enter user name", text: $userName)
                .padding(EdgeInsets(top: 0.0, leading: 50, bottom: 0.0, trailing: 50))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Enter password", text: $password)
                .padding(EdgeInsets(top: 0.0, leading: 50, bottom: 0.0, trailing: 50))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack(spacing: 50) {
                setUpConnectButton()
            }
            .padding()
            Spacer()
        }
        .padding(.bottom, 300)
        .navigationTitle("LogIn")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Configure / enable /disable connect button
    private func setUpConnectButton() -> some View  {
        return Button(action: { getUsers() }) {
                Text("LogIn")
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .blue))
    }
    
    private func getUsers(){
        apiManager.getUsersRequest(usager: userName, motDePasse: password)
        validateUser()
    }
    
    private func validateUser() {        
        if(apiManager.currentAPIstate.userValideState == true){
            showAlert(text: "True")
        }else{
            showAlert(text: "False")
        }
    }
    
    private func showAlert(text: String) {
        alerte = text
        isHidden = false
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
