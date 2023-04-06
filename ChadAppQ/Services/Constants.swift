//
//  Constants.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation
// API Base Urls
struct Domains {
    static let baseUrl = "https://api.chatengine.io/"
    static let socketBaseUrl = "wss://api.chatengine.io/"
}
// API Keys
struct Keys {
    static let privateKey = "24e64b61-e532-4546-8a45-5ec84a2cb4d6"
    static let projectID = "9f65142b-d72a-4667-9b95-db72a5bb950e"
}
// Predefined Users in the Chat Room
struct ChatRoom {
    static let user1 = "rose_byrne"
    static let user2 = "wally_ryan"
}
// For Scrolling to the bottom of the screen
struct ViewIDs {
    static let newChatBottom = UUID()
    static let chatBottom = UUID()
}
// For loading Images with Chat Title on Home View
struct HomeImages {
    static let images = [
        "Support": "person.fill",
        "NYE Perpaid Card": "creditcard.fill",
        "Open Account": "person.crop.circle.badge.plus",
        "Rapi Money": "dollarsign.circle.fill",
        "UPI Payments": "wallet.pass",
        "Check Balance": "externaldrive.badge.checkmark",
        "Change PIN": "person.badge.key",
        "Block Card": "creditcard.trianglebadge.exclamationmark",
        "Issue a new Card": "creditcard.and.123",
        "Salary Account": "bitcoinsign.circle.fill",
        "Fixed Deposit": "coloncurrencysign.circle.fill",
        "Recurring Deposit": "arrow.triangle.2.circlepath.doc.on.clipboard",
        "Joint Account": "person.2.fill",
        "Add Bank Account": "person.fill.badge.plus",
        "Change UPI pin": "pencil.circle.fill",
        "Link your number with UPI ID": "link.circle.fill"
    ]
}
