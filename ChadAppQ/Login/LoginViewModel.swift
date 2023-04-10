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
    
    
//    This func hit My Account Details api if all the fields data is validated
//    It returns Focus State enum which is required for Focusing the TextField that has invalid data
     func loginUser(settings: UserSettings, state: String) -> LoginFocusStates? {
        if !Func.validateUsername(input: usernameTF) {
            usernameError = true
            return .username
        }
        if !Func.validatePassword(input: secretTF) {
            secretError = true
            return .secret
        }
        showLoading = true
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "GET",
            "domain": "users/me/",
            "username": usernameTF,
            "userSecret": secretTF,],
            completionHandler: { data, encodedData in
                do {
                    let decoder = JSONDecoder()
                    var response = try decoder.decode(User.self, from: encodedData!)
                    if let name = response.firstName {
                        response.secret = self.secretTF
                        self.saveData(response, settings: settings)
                    } else {
                        self.textLoginAlert = "Invalid Credentials"
                        self.showLoginAlert = true
                    }
                } catch {
                    print("error in decoding")
                }
                self.showLoading = false
            },
            errorHandler: { err in
            self.textLoginAlert = "Can't reach server at the moment"
            self.showLoginAlert = true
            self.showLoading = false
        })
        return nil
    }
    
//    It saves the user session
//    It saves the API response in User Environment Object
    private func saveData(_ user: User, settings: UserSettings) {
        UserDefaults.standard.set(user.username, forKey: "username")
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
        UserDefaults.standard.set(user.secret, forKey: "secret")
        settings.setUser(user: user)
    }
    
    func checkUsername() {
        usernameError = !Func.validateUsername(input: usernameTF)
    }
    
    func checkSecret() {
        secretError = !Func.validatePassword(input: secretTF)
    }
}
