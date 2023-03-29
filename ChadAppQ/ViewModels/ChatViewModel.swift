//
//  ChatViewModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var chat: Chat
    @Published var settings: UserSettings
    @Published var enteredMessage = ""
    @Published var messages: [Message] = []
    @Published var isTyping = false
    @Published var dataLoaded = false
    @Published var msgSent = true
    
    init(chat: Chat, settings: UserSettings) {
        self.chat = chat
        self.settings = settings
        self.loadMessages()
    }
    
    func showTyping() {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "POST",
            "domain": "chats/\(self.chat.id)/typing/",
            "requestType": .typing as RequestType,
            "username": self.settings.user.username,
            "userSecret": self.settings.user.secret],
            completionHandler: { data in
            
        })
    }
    
    func closeConnection() {
        WSManager.shared.close()
    }
    
    func getTime(_ date: String) -> String {
        return String(date[date.index(date.startIndex, offsetBy: 11)...date.index(date.startIndex, offsetBy: 15)])
    }
    func getDate(_ date: String) -> String {
        return String(date[date.index(date.startIndex, offsetBy: 0)...date.index(date.startIndex, offsetBy: 10)])
    }
    
    func loadMessages() {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "GET",
            "domain": "chats/\(self.chat.id)/messages/",
            "requestType": .getMessages as RequestType,
            "username": self.settings.user.username,
            "userSecret": self.settings.user.secret],
            completionHandler: { data in
                guard let data = data as? [[String: Any]] else {return}
                var currentMsg: [Message] = []
                for value in data {
                    currentMsg.append(Message(id: value["id"] as? Int ?? 0, text: value["text"] as? String ?? "Text", sender: value["sender_username"] as? String ?? "Sender", created: value["created"] as? String ?? "00:00"))
                }
                self.messages = currentMsg
                self.dataLoaded = true
            })
    }
    
    func startSocket() {
        WSManager.shared.setupConnection(chatId: String(chat.id), chatAccessKey: chat.accessKey, completionHandler: { data in
            print(data)
            guard let data = data.toJSON() as? [String: Any] else {return}
            switch ((data["action"] as! String)) {
            case "new_message":
                guard let value = data["data"] as? [String: Any] else {return}
                guard let msg = value["message"] as? [String: Any] else {return}
                if self.settings.user.username != msg["sender_username"] as? String ?? "User-name" {
                    self.messages.append(Message(id: msg["id"] as? Int ?? 0, text: msg["text"] as? String ?? "Text", sender: msg["sender_username"] as? String ?? "Sender", created: msg["created"] as? String ?? "00:00"))
                }
            case "is_typing":
                guard let value = data["data"] as? [String: Any] else {return}
                if self.settings.user.username != value["person"] as! String {
                    self.updateTyping()
                }
            default:
                break
            }
        })
    }
    
    func updateTyping() {
        if self.isTyping != true {
            self.isTyping = true
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.isTyping = false
            }
        }
    }
    
    func sendMessages() {
        if enteredMessage.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return
        }
        self.msgSent = false
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "POST",
            "domain": "chats/\(self.chat.id)/messages/",
            "requestType": .getMessages as RequestType,
            "username": self.settings.user.username,
            "userSecret": self.settings.user.secret,
            "httpBody": ["text": self.enteredMessage]],
            completionHandler: { data in
                guard let data = data as? [String: Any] else {return}
                self.messages.append(Message(id: data["id"] as? Int ?? 0, text: data["text"] as? String ?? "Text", sender: data["sender_username"] as? String ?? "Sender", created: data["created"] as? String ?? "00:00"))
            self.msgSent = true
        })
        enteredMessage = ""
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
