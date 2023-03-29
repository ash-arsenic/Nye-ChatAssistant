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
    
    func startNewChat(questions: FetchedResults<Questions>) {
        self.questions = []
        for que in questions {
            self.questions.append(que)
        }
        showNewChatView = true
    }
    
    func loadChats(questions: FetchedResults<Questions>, settings: UserSettings) {
        if (questions.count == 0) {
            savePredefinedQuestion()
        }
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
                self.fetchingChats = false
        }, errorHandler: { err in
            
        })
    }
    
    func savePredefinedQuestion() {
        let levelOneData = [QuestionModel(id: UUID(), que: "NYE Prepaid Card"),
                    QuestionModel(id: UUID(), que: "Open Account"),
                    QuestionModel(id: UUID(), que: "Rapi Money"),
                    QuestionModel(id: UUID(), que: "UPI Payments")]

                            //NYE PREPAID CARD
        let levelTwoData = [QuestionModel(id: UUID(), parent: levelOneData[0].id, que: "Check Balance"),
                            QuestionModel(id: UUID(), parent: levelOneData[0].id, que: "Change PIN"),
                            QuestionModel(id: UUID(), parent: levelOneData[0].id, que: "Block Card"),
                            QuestionModel(id: UUID(), parent: levelOneData[0].id, que: "Issue a new Card"),

                            // OPEN ACCOUNT
                            QuestionModel(id: UUID(), parent: levelOneData[1].id, que: "Salary Account"),
                            QuestionModel(id: UUID(), parent: levelOneData[1].id, que: "Fixed Deposit"),
                            QuestionModel(id: UUID(), parent: levelOneData[1].id, que: "Recurring Deposit"),
                            QuestionModel(id: UUID(), parent: levelOneData[1].id, que: "Joint Account"),

                            // Rapi Money
                            QuestionModel(id: UUID(), parent: levelOneData[2].id, que: "Pick from the wide options of mutual funds"),
                            QuestionModel(id: UUID(), parent: levelOneData[2].id, que: "Get maximum profit by investing into suggested mutual funds"),

                            // UPI PAYMENTS
                            QuestionModel(id: UUID(), parent: levelOneData[3].id, que: "Add Bank Account"),
                            QuestionModel(id: UUID(), parent: levelOneData[3].id, que: "Change UPI pin"),
                            QuestionModel(id: UUID(), parent: levelOneData[3].id, que: "Link your number with UPI ID")]

                            // NYE PREPAID CARD - CHECK BALANCE
        let levelThreeData = [QuestionModel(id: UUID(), parent: levelTwoData[0].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[0].id, que: "Go to My Cards"),
                              QuestionModel(id: UUID(), parent: levelTwoData[0].id, que: "Click on view balance to check your balance"),

                              // NYE PREPAID CARD - CHANGE PIN
                              QuestionModel(id: UUID(), parent: levelTwoData[1].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[1].id, que: "Go to My Cards"),
                              QuestionModel(id: UUID(), parent: levelTwoData[1].id, que: "Click on change pin"),
                              QuestionModel(id: UUID(), parent: levelTwoData[1].id, que: "Enter new PIN"),
                              QuestionModel(id: UUID(), parent: levelTwoData[1].id, que: "Enter the OTP for completing the process."),

                              // NYE PREPAID CARD - BLOCK CARD
                              QuestionModel(id: UUID(), parent: levelTwoData[2].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[2].id, que: "Go to My Cards"),
                              QuestionModel(id: UUID(), parent: levelTwoData[2].id, que: "Click on block card and enter the reason"),

                              // NYE PREPAID CARD - ISSUE A NEW CARD
                              QuestionModel(id: UUID(), parent: levelTwoData[3].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[3].id, que: "Go to My Cards"),
                              QuestionModel(id: UUID(), parent: levelTwoData[3].id, que: "Click on request new card"),

                              // OPEN ACCOUNT - SALARY ACCOUNT

                              QuestionModel(id: UUID(), parent: levelTwoData[4].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[4].id, que: "Go to My Accounts"),
                              QuestionModel(id: UUID(), parent: levelTwoData[4].id, que: "Apply for Salary Account"),
                              QuestionModel(id: UUID(), parent: levelTwoData[4].id, que: "You will get a ticket for your request"),

                              // OPEN ACCOUNT - FIXED DEPOSIT
                              QuestionModel(id: UUID(), parent: levelTwoData[5].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[5].id, que: "Go to My Accounts"),
                              QuestionModel(id: UUID(), parent: levelTwoData[5].id, que: "Click on My Deposits"),
                              QuestionModel(id: UUID(), parent: levelTwoData[5].id, que: "Click on create new Deposit"),

                              // OPEN ACCOUNT - RECURRING DEPOSIT
                              QuestionModel(id: UUID(), parent: levelTwoData[6].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[6].id, que: "Go to My Account"),
                              QuestionModel(id: UUID(), parent: levelTwoData[6].id, que: "Click on My Deposits"),
                              QuestionModel(id: UUID(), parent: levelTwoData[6].id, que: "Click on create a recurring deposit"),

                              // OPEN ACCOUNT - JOINT ACCOUNT
                              QuestionModel(id: UUID(), parent: levelTwoData[7].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[7].id, que: "Select apply for new Account"),
                              QuestionModel(id: UUID(), parent: levelTwoData[7].id, que: "Select Joint Account from the options and follow the steps"),




                            // UPI - ADD BANK ACCOUNT

                              QuestionModel(id: UUID(), parent: levelTwoData[10].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[10].id, que: "Go to UPI"),
                              QuestionModel(id: UUID(), parent: levelTwoData[10].id, que: "Select Add Bank Account"),
                              QuestionModel(id: UUID(), parent: levelTwoData[10].id, que: "You will recieve a message on success"),

                            // UPI - CHANGE UPI PIN
                              QuestionModel(id: UUID(), parent: levelTwoData[11].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[11].id, que: "Go to UPI"),
                              QuestionModel(id: UUID(), parent: levelTwoData[11].id, que: "Click on change UPI"),
                              QuestionModel(id: UUID(), parent: levelTwoData[11].id, que: "Enter the new PIN"),
                              QuestionModel(id: UUID(), parent: levelTwoData[11].id, que: "Enter the OTP for completing the process"),

                            // UPI - LINK YOUR NUMBER WITH UPI ID
                              QuestionModel(id: UUID(), parent: levelTwoData[12].id, que: "Login to NYE Banking App"),
                              QuestionModel(id: UUID(), parent: levelTwoData[12].id, que: "Go to UPI"),
                              QuestionModel(id: UUID(), parent: levelTwoData[12].id, que: "Click on link number")]

        for question in levelOneData {
            PersistenceController.shared.saveQuestion(que: question.que, id: question.id, parent: question.parent)
        }
        for question in levelTwoData {
            PersistenceController.shared.saveQuestion(que: question.que, id: question.id, parent: question.parent)
        }
        for question in levelThreeData {
            PersistenceController.shared.saveQuestion(que: question.que, id: question.id, parent: question.parent)
        }
    }
    
    func logoutUser(settings: UserSettings) {
        UserDefaults.standard.set("User-name", forKey: "username")
        UserDefaults.standard.set("", forKey: "firstName")
        UserDefaults.standard.set("", forKey: "lastName")
        UserDefaults.standard.set("", forKey: "secret")
        settings.setUser(user: User(username: "User-name", firstName: "", lastName: "", secret: ""))
    }
}
