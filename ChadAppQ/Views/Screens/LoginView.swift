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
            
            VStack {
                HStack {
                    Text("Welcome Back,")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                    Spacer()
                }.padding(.bottom, 4)
                HStack {
                    Text("Sign in to your  Chad App account")
                        .font(.title2.weight(.heavy))
                        .kerning(2)
                    Spacer()
                }
            }.padding(.bottom, 36)
            
            ChadTextField(title: "Your Username", text: $vm.usernameTF, showError: $vm.usernameError)
                .focused($focusedTF, equals: .username)
                .onSubmit {
                    vm.checkUsername()
                    focusedTF = .secret
                }.padding(.top, 24)
            ChadPasswordField(title: "Your Password", text: $vm.secretTF, showError: $vm.secretError)
                .focused($focusedTF, equals: .secret)
                .onSubmit {
                    vm.checkSecret()
                }
            
            ChadButton(label: "LOGIN", action: {
                focusedTF = nil
                DispatchQueue.main.asyncAfter(deadline: .now()+0.001) {
                    focusedTF = vm.loginUser(settings: self.settings)
                }
            }, loading: $vm.showLoading)
            .alert("Invalid Credentials", isPresented: $vm.showLoginAlert) {}
            
            HStack {
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
