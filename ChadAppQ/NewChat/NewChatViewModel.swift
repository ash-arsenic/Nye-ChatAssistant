//
//  NewChatViewModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation
import SwiftUI

class NewChatViewModel: ObservableObject {
    @Published var showChatView = false
    @Published var chat: Chat?
    @Published var questions: [QuestionModel] = []
    @Published var showErrorAlert = false
    @Published var textErrorAlert = "Can't reach server at the moment"
    @Published var showLoading = false
    
    var allQuestions: [Questions]
    var optionalChat = Chat(id: 1, sender: "Sender", receiever: "Reciever", title: "Title", accessKey: "7", lastMessage: "No messages")
    var chatTitle = "Support"
    
    init(allQuestions: [Questions]) {
        self.allQuestions = allQuestions
        self.showStartingQuestions()
    }
    
//    This functions returns the list of Questions whose Parent field matchs the given ID
    private func loadQuestions(parent: UUID?) -> [Questions] {
        let ques = allQuestions.filter { question in
            return question.parent == parent
        }
        return ques
    }
    
//    This func shows the questions that has no parent
    func showStartingQuestions() {
        questions = []
        let ques = loadQuestions(parent: nil)
        for que in ques {
            questions.append(QuestionModel(id: que.id!, parent: que.parent, que: que.que!))
        }
    }
    
//    This func adds the Child Question to the list if there is any child to clicked question
//    This func also appends the clicked item to the list as User response (fromBot = false)
//    It also keeps track of the last clicked Item(with children) in chatTitle
    func continueProcess(question: QuestionModel) {
        if question.fromBot {
            let ques = loadQuestions(parent: question.id)
            if ques.count != 0 {
                questions.append(QuestionModel(id: UUID(), parent: UUID(), que: question.que, fromBot: false))
                chatTitle = question.que
            }
            for que in ques {
                questions.append(QuestionModel(id: que.id!, parent: que.parent, que: que.que!))
            }
        }
    }
    
//    This func hits Create Chat api to create a new chat
//    If the current user is wally_ryan then other user in Chat will be rose_byrne and vice-versa
//    On successful creation of chat it shows the next screen
//    If the chat room already exist with same title and same users then that chat room will be opened.
//    New chat room can only be made with different chat title or different users.
    func createChat(settings: UserSettings) {
        showLoading = true
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "PUT",
            "domain": "chats/",
            "username": settings.user.username ?? "Username",
            "userSecret": settings.user.secret ?? "Secret",
            "createChat": CreateChat(usernames: [settings.user.username == ChatRoom.user1 ? ChatRoom.user2 : ChatRoom.user1], title: chatTitle)],
            completionHandler: { data, encodedData in
            print(data)
            guard let value = data as? [String: Any] else {return}
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
            var lastMessage = lastMessaggeDetails?["text"] as? String ?? "No Messages"
            lastMessage = lastMessage.count == 0 ? "No Messages" : lastMessage
            self.chat = Chat(id: id, sender: sender, receiever: receiver, title: title, accessKey: accessKey, lastMessage: lastMessage)
            self.showChatView = true
            self.showLoading = false
        },
        errorHandler: { err in
            self.textErrorAlert = "Can't reach server at the moment"
            self.showErrorAlert = true
            self.showLoading = false
        })
    }
}
