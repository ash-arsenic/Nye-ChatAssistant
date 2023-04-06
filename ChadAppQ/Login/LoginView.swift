//
//  LoginView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 24/03/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var settings: UserSettings
    @StateObject private var vm = LoginViewModel()
    @FocusState private var focusedTF: LoginFocusStates?
    
    var body: some View {
        VStack {
            VStack { // For better UI
                Image("ChatAppIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Welcome to Chat App")
                    .font(.title.bold())
                    .foregroundColor(Color(red: 0.031, green: 0.314, blue: 0.408, opacity: 1.0))
                Text("Please fill your login details")
                    .font(.headline.weight(.bold))
                    .foregroundColor(Color.gray)
            }.padding(.bottom, 36)
            // Custom Textfield
            ChadTextField(title: "Your Username", text: $vm.usernameTF, showError: $vm.usernameError)
                .focused($focusedTF, equals: .username)
                .onSubmit {
                    vm.checkUsername()
                    focusedTF = .secret
                }.padding(.top, 24)
            // Custom Password Field
            ChadPasswordField(title: "Your Password", text: $vm.secretTF, showError: $vm.secretError)
                .focused($focusedTF, equals: .secret)
                .onSubmit {
                    vm.checkSecret()
                }
            // Custom Button
            ChadButton(label: "LOGIN", action: {
                focusedTF = nil
                DispatchQueue.main.asyncAfter(deadline: .now()+0.001) { // For toggling focus of the Textfield
                    focusedTF = vm.loginUser(settings: self.settings, state: "true")
                }
            }, loading: $vm.showLoading)
            .alert(vm.textLoginAlert, isPresented: $vm.showLoginAlert) {}
            
            HStack { // For navigating to signup page
                Text("Don't have an account?")
                    .font(.headline)
                    .foregroundColor(Color.gray)
                NavigationLink(destination: SignupView(), isActive: $vm.showSingup) {
                    Button("Sign up") {
                        vm.showSingup = true
                    }.foregroundColor(Color("Primary"))
                }
            }.padding(.top, UIScreen.main.bounds.height * 0.2)
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
