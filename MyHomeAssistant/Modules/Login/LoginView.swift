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
    @State var isDisabled: Bool = false
    @State var buttonColor: String = "teal"
    @EnvironmentObject var apiManager: APIManager
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.teal
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)

                VStack {
                    Spacer()
                    Text("My School Assistant")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    if(isHidden == false){
                        Text("Wrong email and/or password!")
                            .foregroundColor(.red)
                    }
                    
                    TextField("Enter Email", text: $userName)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    
                    SecureField("Enter Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    Button("LogIn" ,action: {
                        getUsers()
                    })
                    .disabled(isDisabled)
                    .navigationDestination(isPresented: $isAuthenticated) {
                        AlarmView()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.teal)
                    .cornerRadius(10)
                    Spacer()
                }
                .navigationTitle("")
            }
        }
    }
    
    private func getUsers(){
        isDisabled = true
        apiManager.getUsersRequest(usager: userName, motDePasse: password)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            validateUser()
        })
    }
    
    private func validateUser() {        
        if(apiManager.currentAPIState.userValideState == true){
            isAuthenticated = true
        }
        else{
            isHidden = false
            isDisabled = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
