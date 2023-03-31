//
//  NetworkManager.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

enum RequestType: String {
    case createUser
    case loginUser
    case createChat
    case getChats
    case sendMessage
    case getMessages
    case typing
}

struct CreateChat: Encodable {
    var usernames: [String]
    var title: String
    var is_direct_chat = true
    
    init(usernames: [String], title: String) {
        self.usernames = usernames
        self.title = title
    }
}

class NetworkManager {
    static let shared = NetworkManager()
        
    func requestForApi(requestInfo: [String: Any], completionHandler: ((Any)->())?, errorHandler: ((Any)->())?) {
        var request = URLRequest(url: URL(string: Domains.baseUrl + (requestInfo["domain"] as! String))!)
        request.httpMethod = requestInfo["httpMethod"] as? String ?? "GET"
        
        if let httpBody = requestInfo["httpBody"] as? [String: String] {
            request.httpBody = try! JSONEncoder().encode(httpBody)
        }
        if let createChat = requestInfo["createChat"] as? CreateChat {
            request.httpBody = try! JSONEncoder().encode(createChat)
        }
        switch requestInfo["requestType"] as! RequestType {
        case .createUser:
            request.addValue(Keys.privateKey, forHTTPHeaderField: "PRIVATE-KEY")
        default:
            request.addValue(Keys.projectID, forHTTPHeaderField: "Project-ID")
            request.addValue(requestInfo["username"] as! String, forHTTPHeaderField: "User-Name")
            request.addValue(requestInfo["userSecret"] as! String, forHTTPHeaderField: "User-Secret")
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, err in
            if let err = err {
                print("Received some error in api \(err.localizedDescription)")
                DispatchQueue.main.async {
                    errorHandler?(err)
                }
                return
            }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) else {
                print("Getting some error on json Sericliaxation")
                return
            }
            DispatchQueue.main.async {
                completionHandler?(jsonData)
            }
        }.resume()
    }
}
