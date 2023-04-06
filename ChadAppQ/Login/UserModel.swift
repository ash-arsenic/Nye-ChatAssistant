//
//  UserModel.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

struct User: Codable {
    var username: String?
    var firstName: String?
    var lastName: String?
    var secret: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case secret = "secret"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
