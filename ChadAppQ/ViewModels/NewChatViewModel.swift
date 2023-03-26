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
    var allQuestions: FetchedResults<Questions>?
    var optionalChat = Chat(id: 1, sender: "Sender", receiever: "Reciever", title: "Title", accessKey: "7", lastMessage: "No messages")
    var chatTitle = "Support"
    
    func loadQuestions(parent: UUID?) -> [FetchedResults<Questions>.Element] {
        let ques = allQuestions!.filter { question in
            return question.parent == parent
        }
        return ques
    }
    
    func showStartingQuestions(allQuestions: FetchedResults<Questions>) {
        self.allQuestions = allQuestions
        questions = []
        let ques = loadQuestions(parent: nil)
        for que in ques {
            questions.append(QuestionModel(id: que.id!, parent: que.parent, que: que.que!))
        }
    }
    
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
    
    func createChat(settings: UserSettings) {
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "PUT",
            "domain": "chats/",
            "requestType": .createChat as RequestType,
            "username": settings.user.username,
            "userSecret": settings.user.secret,
            "createChat": CreateChat(usernames: [ChatRoom.user], title: chatTitle)],
            completionHandler: { data in
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
        })
    }
}
