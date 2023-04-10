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
    
//    This func hit Create User api if all the fields data is validated
//    It returns Focus State enum which is required for Focusing the TextField that has invalid data
    func signupUser() -> FocusStates? {
        if !Func.validateUsername(input: usernameTF) {
            usernameError = true
            return .username
        }
        if !Func.validateName(input: firstNameTF) {
            firstNameError = true
            return .firstName
        }
        if !Func.validateName(input: lastNameTF) {
            lastNameError = true
            return .lastName
        }
        if !Func.validatePassword(input: secretTF) {
            secretError = true
            return .secret
        }
        showLoading = true
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "POST",
            "domain": "users/",
            "createUser": true,
            "httpBody": [ "username": usernameTF, "first_name": firstNameTF, "last_name": lastNameTF, "secret": secretTF]],
            completionHandler: { data, encodedData in
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
//        if Func.validateUsername(input: usernameTF) {
//            if Func.validateName(input: firstNameTF) {
//                if Func.validateName(input: lastNameTF) {
//                    if Func.validatePassword(input: secretTF) {
//                        showLoading = true
//                        NetworkManager.shared.requestForApi(requestInfo: [
//                            "httpMethod": "POST",
//                            "domain": "users/",
//                            "createUser": true,
//                            "httpBody": [ "username": usernameTF, "first_name": firstNameTF, "last_name": lastNameTF, "secret": secretTF]],
//                            completionHandler: { data, encodedData in
//                            print(data)
//                            guard let data = data as? [String: Any] else {return}
//                            if let data = data["first_name"] as? String {
//                                self.showSingupAlert = true
//                            } else {
//                                self.textSingupErrorAlert = "Username already taken"
//                                self.showSingupErrorAlert = true
//                            }
//                            self.showLoading = false
//                        },
//                        errorHandler: { err in
//                            self.textSingupErrorAlert = "Can't reach server at the moment"
//                            self.showSingupErrorAlert = true
//                            self.showLoading = false
//                        })
//                        return nil
//                    } else {
//                        secretError = true
//                        return .secret
//                    }
//                } else {
//                    lastNameError = true
//                    return .lastName
//                }
//            } else {
//                firstNameError = true
//                return .firstName
//            }
//        } else {
//            usernameError = true
//            return .username
//        }
    }
    
//    Checks Username
    func checkUsername() {
        usernameError = !Func.validateUsername(input: usernameTF)
    }
    
//    Checks First Name
    func checkFirstName() {
        firstNameError = !Func.validateName(input: firstNameTF)
    }
    
//    Checks Last Name
    func checkLastName() {
        lastNameError = !Func.validateName(input: lastNameTF)
    }
    
//    Checks Secret
    func checkSecret() {
        secretError = !Func.validatePassword(input: secretTF)
    }
}
