//
//  NetworkManager.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

//    Func for Making any type of API Call. RequestInfo is the dictionary with all the necessary data required for making a specific call.
//    Completion Handler Closure is called on getting response from the API.
//    Error Handler closure is called on unsuccessful API call.
//    URL Session Library is used for making Api Call.
    
    func requestForApi(requestInfo: [String: Any], completionHandler: ((Any, Data?)->())?, errorHandler: ((Any)->())?) {
        var request = URLRequest(url: URL(string: Domains.baseUrl + (requestInfo["domain"] as! String))!)
        request.httpMethod = requestInfo["httpMethod"] as? String ?? "GET"
        
        if let httpBody = requestInfo["httpBody"] as? [String: String] {
            request.httpBody = try! JSONEncoder().encode(httpBody)
        }
        if let createChat = requestInfo["createChat"] as? CreateChat {
            request.httpBody = try! JSONEncoder().encode(createChat)
        }
        if let createUser = requestInfo["createUser"] as? Bool {
            request.addValue(Keys.privateKey, forHTTPHeaderField: "PRIVATE-KEY")
        } else {
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
                DispatchQueue.main.async {
                    errorHandler?(err)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler?(jsonData, data!)
            }
        }.resume()
    }
}
