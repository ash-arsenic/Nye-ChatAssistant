//
//  MessageModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

struct Message: Identifiable {
    var id: Int
    var text: String
    var sender: String
    var created: String
    var messageSent: Bool
    var messageRead: Bool
}
