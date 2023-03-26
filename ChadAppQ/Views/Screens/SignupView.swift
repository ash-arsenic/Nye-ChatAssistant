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
                HStack {
                    Text("Hey There,")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                    Spacer()
                }.padding(.bottom, 4)
                HStack {
                    Text("Sign up to get Chad App")
                        .font(.title2.weight(.heavy))
                        .kerning(2)
                    Spacer()
                }
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
            }.alert("Username Already Taken", isPresented: $vm.showSingupErrorAlert) {}
        }.padding()
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
