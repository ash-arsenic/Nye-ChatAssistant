//
//  LoginViewModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 24/03/23.
//

import Foundation
import SwiftUI

enum LoginFocusStates {
    case username
    case secret
}

class LoginViewModel: ObservableObject {
    @Published var usernameTF = ""
    @Published var secretTF = ""
    
    @Published var usernameError = false
    @Published var secretError = false
    
    @Published var showLoading = false
    @Published var showSingup = false
    @Published var showLoginAlert = false
    @Published var textLoginAlert = "Invalid Credentials"
    
    func loginUser(settings: UserSettings) -> LoginFocusStates? {
        if validateUsername(input: usernameTF) {
            if validatePassword(input: secretTF) {
                showLoading = true
                NetworkManager.shared.requestForApi(requestInfo: [
                    "httpMethod": "GET",
                    "domain": "users/me/",
                    "requestType": .loginUser as RequestType,
                    "username": usernameTF,
                    "userSecret": secretTF],
                    completionHandler: { data in
                        guard let data = data as? [String: Any] else {return}
                        if let suc = data["first_name"] as? String {
                            self.saveData(User(username: self.usernameTF, firstName: data["first_name"] as! String, lastName: data["last_name"] as! String, secret: self.secretTF), settings: settings)
                        } else {
                            self.textLoginAlert = "Invalid Credentials"
                            self.showLoginAlert = true
                        }
                        self.showLoading = false
                    },
                    errorHandler: { err in
                    self.textLoginAlert = "Can't reach server at the moment"
                    self.showLoginAlert = true
                    self.showLoading = false
                })
                return nil
            } else {
                secretError = true
                return .secret
            }
        } else {
            usernameError = true
            return .username
        }
    }
    
    func saveData(_ user: User, settings: UserSettings) {
        UserDefaults.standard.set(user.username, forKey: "username")
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
        UserDefaults.standard.set(user.secret, forKey: "secret")
        settings.setUser(user: user)
    }
    
    func checkUsername() {
        usernameError = !validateUsername(input: usernameTF)
    }
    
    func checkSecret() {
        secretError = !validatePassword(input: secretTF)
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
