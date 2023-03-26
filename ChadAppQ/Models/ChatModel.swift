//
//  ChatModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

struct Chat: Identifiable {
    var id: Int
    var sender: String
    var receiever: String
    var title: String
    var accessKey: String
    var lastMessage: String
}
