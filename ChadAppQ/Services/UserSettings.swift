//
//  UserSettings.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var user: User
    @Published var questions: [Questions] = []
    
    init() {
        self.user = User(username: UserDefaults.standard.value(forKey: "username") as? String ?? "User-name",
                         firstName: UserDefaults.standard.value(forKey: "firstName") as? String ?? "FirstName",
                         lastName: UserDefaults.standard.value(forKey: "lastName") as? String ?? "LastName",
                         secret: UserDefaults.standard.value(forKey: "secret") as? String ?? "Secret")
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    func setQues(questions: [Questions]) {
        self.questions = questions
    }
}
