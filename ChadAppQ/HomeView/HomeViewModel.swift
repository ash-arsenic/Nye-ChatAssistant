//
//  HomeViewModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var chats: [Chat] = []
    @Published var showNewChatView = false
    @Published var questions: [Questions] = []
    @Published var showLogoutAlert = false
    @Published var fetchingChats = true
    @Published var showErrorAlert = false
    @Published var textErrorAlert = "Cant reach server at the moment"
    
//    It shows the new chat screen and sends all the questions from core data
    func startNewChat(questions: FetchedResults<Questions>) {
        self.questions = []
        for que in questions {
            self.questions.append(que)
        }
        showNewChatView = true
    }
    
//    It hits Get my Chats api and loads the previous chat
    func loadChats(questions: FetchedResults<Questions>, settings: UserSettings) {
        if (questions.count == 0) {
            Func.savePredefinedQuestion()
        }
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "GET",
            "domain": "chats/",
            "username": settings.user.username ?? "Username",
            "userSecret": settings.user.secret ?? "Password"],
            completionHandler: { data, encodedData in
                guard let data = data as? [[String: Any]] else {return}
                var currentChats: [Chat] = []
                for value in data {
                    let admin = value["admin"] as? [String: Any]
                    let sender = admin?["username"] as? String ?? "Sender"
                    let people = value["people"] as? [[String: Any]]
                    let sam = people?[0] as? [String: Any]
                    let person = sam?["person"] as? [String: Any]
                    let receiver = person?["username"] as? String ?? "Receiver"
                    let title = value["title"] as? String ?? "Title"
                    let id = value["id"] as? Int ?? 0
                    let accessKey = value["access_key"] as? String ?? "8"
                    let lastMessaggeDetails = value["last_message"] as? [String: Any]
                    var lastMessage = lastMessaggeDetails!["text"] as? String ?? "No Messages"
                    lastMessage = lastMessage.count == 0 ? "No Messages" : lastMessage
                    currentChats.append(Chat(id: id, sender: sender, receiever: receiver, title: title, accessKey: accessKey, lastMessage: lastMessage))
                }
                self.chats = currentChats
                self.fetchingChats = false
        }, errorHandler: { err in
            self.textErrorAlert = "Can't reach server at the moment"
            self.showErrorAlert = true
            self.fetchingChats = false
        })
    }
    
//    It logouts the user by setting username to "User-name"
//    If user is created from the App then the username can never be User-name bcz it violates the Validation policies set in Signup page
//    It empties all the fiel   ds
    func logoutUser(settings: UserSettings) {
        UserDefaults.standard.set("User-name", forKey: "username")
        UserDefaults.standard.set("", forKey: "firstName")
        UserDefaults.standard.set("", forKey: "lastName")
        UserDefaults.standard.set("", forKey: "secret")
        settings.setUser(user: User(username: "User-name", firstName: "", lastName: "", secret: ""))
    }
}
