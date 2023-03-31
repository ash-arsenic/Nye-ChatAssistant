//
//  SignupView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var vm = SignupViewModel()
    @FocusState var focusedTF: FocusStates?
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            VStack {
                Image("ChatAppIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Welcome to Chat App")
                    .font(.title.bold())
                    .foregroundColor(Color(red: 0.031, green: 0.314, blue: 0.408, opacity: 1.0))
                Text("Please fill the details and create account")
                    .font(.headline.weight(.bold))
                    .foregroundColor(Color.gray)
            }.padding(.bottom, 36)
            
            ChadTextField(title: "Enter Username", text: $vm.usernameTF, showError: $vm.usernameError)
                .padding(.top, 24)
                .focused($focusedTF, equals: .username)
                .onSubmit {
                    vm.checkUsername()
                    focusedTF = .firstName
                }
            
            ChadTextField(title: "Enter First Name", text: $vm.firstNameTF, showError: $vm.firstNameError)
                .focused($focusedTF, equals: .firstName)
                .onSubmit {
                    vm.checkFirstName()
                    focusedTF = .lastName
                }
            
            ChadTextField(title: "Enter Last Name", text: $vm.lastNameTF, showError: $vm.lastNameError)
                .focused($focusedTF, equals: .lastName)
                .onSubmit {
                    vm.checkLastName()
                    focusedTF = .secret
                }
            
            ChadPasswordField(title: "Choose Password", text: $vm.secretTF, showError: $vm.secretError)
                .focused($focusedTF, equals: .secret)
                .onSubmit {
                    vm.checkSecret()
                }
            
            ChadButton(label: "SIGNUP", action: {
                focusedTF = nil
                DispatchQueue.main.asyncAfter(deadline: .now()+0.001) {
                    focusedTF = vm.signupUser()
                }
            }, loading: $vm.showLoading)
            .alert("Signed up successfully", isPresented: $vm.showSingupAlert) {
                Button("GO TO SIGN IN") {
                    self.presentation.wrappedValue.dismiss()
                }
            }.alert(vm.textSingupErrorAlert, isPresented: $vm.showSingupErrorAlert) {}
        }.padding()
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
