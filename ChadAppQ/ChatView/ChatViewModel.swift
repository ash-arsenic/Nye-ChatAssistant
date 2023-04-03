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
    @Published var currentStatus = "Offline"
    @Published var showErrorAlert = false
    @Published var textErrorAlert = "Can't reach server at the moment"
    @Published var unsentMessages: [String] = []
    
    init(chat: Chat, settings: UserSettings) {
        self.chat = chat
        self.settings = settings
    }
    
//    It hits Update My Account Api and set the isOnline Status of the user true or false according to state.
//    It is called onAppear of the ChatView with state = "true" and onDisappear of the ChatView with state = "false"
    func makeUserOnline(state: String) {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "PATCH",
            "domain": "users/me/",
            "username": self.settings.user.username,
            "userSecret": self.settings.user.secret,
            "httpBody": ["is_online": state]],
            completionHandler: { data in
            },
            errorHandler: { err in
            self.textErrorAlert = "Can't reach server at the moment"
            self.showErrorAlert = true
        })
    }
    
//    It hits Show Typing Api whose response is received in the socket.
    func showTyping() {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "POST",
            "domain": "chats/\(self.chat.id)/typing/",
            "username": self.settings.user.username,
            "userSecret": self.settings.user.secret],
            completionHandler: { data in
            
        }, errorHandler: { err in
            
        })
    }
    
//    This function set user status offline and Close the socket connection
    func closeConnection() {
        self.makeUserOnline(state: "false")
        WSManager.shared.close()
    }
    
//    Parsing Time from the created String (hh:mm)
    func getTime(_ date: String) -> String {
        return String(date[date.index(date.startIndex, offsetBy: 11)...date.index(date.startIndex, offsetBy: 15)])
    }
    
//    Parsing Date from the Created String (yyyy-mm-dd)
    func getDate(_ date: String) -> String {
        return String(date[date.index(date.startIndex, offsetBy: 0)...date.index(date.startIndex, offsetBy: 10)])
    }
    
//    For making the read Message double tick
//    msgID is the id of the last read message
    func updateReadMessages(msgId: Int) {
        var index = 0
        for i in (0..<messages.count).reversed() {
            index = i
            if messages[i].id == msgId {
                break
            }
        }
        if messages.isEmpty {
            return
        }
        for i in (0...index).reversed() {
            if messages[i].messageRead {
                break
            }
            messages[i].messageRead = true
        }
    }
    
//    This function hits Read message API and updates the last read message of a user in a chat
    func readMessage(msgId: Int) {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "PATCH",
            "domain": "chats/\(self.chat.id)/people/",
            "username": self.settings.user.username,
            "userSecret": self.settings.user.secret,
            "httpBody": ["last_read": String(msgId)]],
            completionHandler: { data in
                print("Read Message: \(msgId)")
            }, errorHandler: { err in
                    self.textErrorAlert = "Can't reach the server"
                    self.showErrorAlert = true
            })
    }
    
//    This function hits the Get Chat Details and extract Online/Offline status and Last Read msg ID from the Response
    func fetchChatDetails() {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "GET",
            "domain": "chats/\(chat.id)/",
            "username": settings.user.username,
            "userSecret": settings.user.secret],
            completionHandler: { data in
                guard let value = data as? [String: Any] else {return}
                let people = value["people"] as? [[String: Any]]
                let person1 = people?[0]["person"] as? [String: Any]
                let person2 = people?[1]["person"] as? [String: Any]
                var person: [String: Any]?
                let msgID: Int?
                if person1?["username"] as? String == self.settings.user.username {
                    person = person2
                    msgID = people?[1]["last_read"] as? Int
                } else {
                    person = person1
                    msgID = people?[0]["last_read"] as? Int
                }
                var isOnline = person?["is_online"] as? Bool
                self.currentStatus = isOnline ?? false ? "Online" : "Offline"
                if let msgID = msgID {
                    self.updateReadMessages(msgId: msgID)
                }
                self.dataLoaded = true
        }, errorHandler: { err in
        })
    }
    
//    This function hits Get my messages API and extract the required msg info and then calls fetchChatDetails() which will update the UI
    func loadMessages() {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "GET",
            "domain": "chats/\(self.chat.id)/messages/",
            "username": self.settings.user.username,
            "userSecret": self.settings.user.secret],
            completionHandler: { data in
                guard let data = data as? [[String: Any]] else {return}
                var currentMsg: [Message] = []
                for value in data {
                    currentMsg.append(Message(id: value["id"] as? Int ?? 0, text: value["text"] as? String ?? "Text", sender: value["sender_username"] as? String ?? "Sender", created: value["created"] as? String ?? "00:00", messageSent: true, messageRead: false))
                }
                for msg in currentMsg.reversed() {
                    if msg.sender != self.settings.user.username {
                        print("Last msg: \(msg.text)")
                        self.readMessage(msgId: msg.id)
                        break
                    }
                }
                self.messages = currentMsg
                self.fetchChatDetails()
            }, errorHandler: { err in
                self.textErrorAlert = "Can't reach the server"
                self.showErrorAlert = true
            })
    }
    
//    This function sets up the socket and Recieves the data
//    The recieved data is of three types: 1) New Message 2) Reciever is typing 3) Reciever is online/offline and Reciever read the message
//    It also calls makeUserOnline to set the status of current user online
    func startSocket() {
        WSManager.shared.setupConnection(chatId: String(chat.id), chatAccessKey: chat.accessKey, completionHandler: { data in
            guard let data = data.toJSON() as? [String: Any] else {return}
            switch ((data["action"] as! String)) {
            case "new_message":
                guard let value = data["data"] as? [String: Any] else {return}
                guard let msg = value["message"] as? [String: Any] else {return}
                if self.settings.user.username != msg["sender_username"] as? String ?? "User-name" {
                    self.messages.append(Message(id: msg["id"] as? Int ?? 0, text: msg["text"] as? String ?? "Text", sender: msg["sender_username"] as? String ?? "Sender", created: msg["created"] as? String ?? "00:00", messageSent: true, messageRead: false))
                    self.readMessage(msgId: msg["id"] as? Int ?? 0)
                }
            case "is_typing":
                guard let value = data["data"] as? [String: Any] else {return}
                if self.settings.user.username != value["person"] as! String {
                    self.updateTyping()
                }
            case "edit_chat":
                guard let value = data["data"] as? [String: Any] else {return}
                let people = value["people"] as? [[String: Any]]
                let person1 = people?[0]["person"] as? [String: Any]
                let person2 = people?[1]["person"] as? [String: Any]
                let person: [String: Any]?
                let msgID: Int?
                if person1?["username"] as? String == self.settings.user.username {
                    person = person2
                    msgID = people?[1]["last_read"] as? Int
                } else {
                    person = person1
                    msgID = people?[0]["last_read"] as? Int
                }
                let isOnline = person?["is_online"] as? Bool
                self.currentStatus = isOnline ?? false ? "Online" : "Offline"
                if let msgID = msgID {
                    self.updateReadMessages(msgId: msgID)
                }
            default:
                break
            }
        })
        self.makeUserOnline(state: "true")
    }
    
// This functions update the UI of reciever is typing
    func updateTyping() {
        if self.isTyping != true {
            self.isTyping = true
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.isTyping = false
            }
        }
    }
    
//    This func hits Create Chat Message api for creating new message in a particular Chat
//    It first adds the message into unsent message queue the DEQUEUE from the list as they are sent
    func sendMessages() {
        if enteredMessage.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return
        }
        unsentMessages.append(enteredMessage)
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "POST",
            "domain": "chats/\(self.chat.id)/messages/",
            "username": self.settings.user.username,
            "userSecret": self.settings.user.secret,
            "httpBody": ["text": self.enteredMessage]],
            completionHandler: { data in
                guard let data = data as? [String: Any] else {return}
                self.unsentMessages.remove(at: 0)
                self.messages.append(Message(id: data["id"] as? Int ?? 0, text: data["text"] as? String ?? "Text", sender: data["sender_username"] as? String ?? "Sender", created: data["created"] as? String ?? "00:00", messageSent: true, messageRead: false))
        }, errorHandler: { err in
            self.textErrorAlert = "Can't reach the server"
            self.showErrorAlert = true
            self.msgSent = true
        })
        enteredMessage = ""
    }
}

//  The response recieved in socket is in String from which is needed to be parsed into JSON object.
//  This extension adds the above functionality
extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
