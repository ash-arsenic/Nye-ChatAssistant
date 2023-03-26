//
//  HomeViewModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var chats: [Chat] = []
    @Published var showNewChatView = false
    
    func loadChats(settings: UserSettings) {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "GET",
            "domain": "chats/",
            "requestType": .getChats as RequestType,
            "username": settings.user.username,
            "userSecret": settings.user.secret],
            completionHandler: { data in
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
        })
    }
    
    func logoutUser(settings: UserSettings) {
        UserDefaults.standard.set("User-name", forKey: "username")
        UserDefaults.standard.set("", forKey: "firstName")
        UserDefaults.standard.set("", forKey: "lastName")
        UserDefaults.standard.set("", forKey: "secret")
        settings.setUser(user: User(username: "User-name", firstName: "", lastName: "", secret: ""))
    }
}
