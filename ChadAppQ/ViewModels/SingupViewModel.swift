//
//  SingupViewModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

enum FocusStates {
    case username
    case secret
    case firstName
    case lastName
}

class SignupViewModel: ObservableObject {
    
    @Published var usernameTF = ""
    @Published var firstNameTF = ""
    @Published var lastNameTF = ""
    @Published var secretTF = ""
    
    @Published var usernameError = false
    @Published var secretError = false
    @Published var firstNameError = false
    @Published var lastNameError = false
    
    @Published var showLoading = false
    @Published var showSingupAlert = false
    @Published var showSingupErrorAlert = false
    @Published var textSingupErrorAlert = "Username already taken"
    
    
    var focused: FocusStates?
    
    func signupUser() -> FocusStates? {
        if validateUsername(input: usernameTF) {
            if validateName(input: firstNameTF) {
                if validateName(input: lastNameTF) {
                    if validatePassword(input: secretTF) {
                        showLoading = true
                        NetworkManager.shared.requestForApi(requestInfo: [
                            "httpMethod": "POST",
                            "domain": "users/",
                            "requestType": .createUser as RequestType,
                            "httpBody": [ "username": usernameTF, "first_name": firstNameTF, "last_name": lastNameTF, "secret": secretTF]],
                            completionHandler: { data in
                            print(data)
                            guard let data = data as? [String: Any] else {return}
                            if let data = data["first_name"] as? String {
                                self.showSingupAlert = true
                            } else {
                                self.textSingupErrorAlert = "Username already taken"
                                self.showSingupErrorAlert = true
                            }
                            self.showLoading = false
                        },
                        errorHandler: { err in
                            self.textSingupErrorAlert = "Can't reach server at the moment"
                            self.showSingupErrorAlert = true
                            self.showLoading = false
                        })
                        return nil
                    } else {
                        secretError = true
                        return .secret
                    }
                } else {
                    lastNameError = true
                    return .lastName
                }
            } else {
                firstNameError = true
                return .firstName
            }
        } else {
            usernameError = true
            return .username
        }
    }
    
    func checkUsername() {
        usernameError = !validateUsername(input: usernameTF)
    }
    func checkFirstName() {
        firstNameError = !validateName(input: firstNameTF)
    }
    func checkLastName() {
        lastNameError = !validateName(input: lastNameTF)
    }
    func checkSecret() {
        secretError = !validatePassword(input: secretTF)
    }
    
    func validateName(input: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", "\\w{2,26}")
        return test.evaluate(with: input)
    }
    
    func validateUsername(input: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", "\\w{7,18}")
        return test.evaluate(with: input)
    }
    
    func validatePassword(input: String) -> Bool {
        let pswdRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let pswdPred = NSPredicate(format:"SELF MATCHES %@", pswdRegEx)
        return pswdPred.evaluate(with: input)
    }
}
