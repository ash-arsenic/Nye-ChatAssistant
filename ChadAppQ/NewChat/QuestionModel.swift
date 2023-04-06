//
//  QuestionModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

struct QuestionModel: Identifiable {
    var id: UUID
    var parent: UUID?
    var que: String
    var fromBot: Bool
    
    init(id: UUID, parent: UUID? = nil, que: String, fromBot: Bool = true) {
        self.id = id
        self.parent = parent
        self.que = que
        self.fromBot = fromBot
    }
}

// Used During Sending API Request of Create New Chat
struct CreateChat: Encodable {
    var usernames: [String]
    var title: String
    var is_direct_chat = true
    
    init(usernames: [String], title: String) {
        self.usernames = usernames
        self.title = title
    }
}
