//
//  SocketManager.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import Foundation
import SwiftUI

enum SocketAction: String {
    case typing = "is_typing"
    case recievedMsg = "new_message"
}

class WSManager: NSObject, URLSessionWebSocketDelegate {
    static let shared = WSManager()
    private var webSocket: URLSessionWebSocketTask?
    var completionHandler: ((String)->())?
    
//    This function intialise completionHandler class variable and sets up the socket.
    func setupConnection(chatId: String, chatAccessKey: String, completionHandler: @escaping ((String)->())) {
        self.completionHandler = completionHandler
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "\(Domains.socketBaseUrl)chat/?projectID=\(Keys.projectID)&chatID=\(chatId)&accessKey=\(chatAccessKey)")
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
    }
    
//    For testing if the socket is working perfectly
    func ping() {
        webSocket?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Ping error: \(error)")
            }
        })
    }
    
//    For closing the connection
    func close() {
        webSocket?.cancel(with: .goingAway, reason: "Gone".data(using: .utf8))
    }
    
//    This function is not used anywhere. Just for the future reference
    func send() {
        webSocket?.send(.string("Message from Ashish"), completionHandler: { error in
            if let error = error {
                print("Send error: \(error)")
            } else {
                print("Msg sent successfully")
            }
        })
    }
    
//    If the result is recieved the Completion Handler is called
//    It uses recursion
    func recieve() {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case .string(let message):
                    DispatchQueue.main.async {
                        self!.completionHandler!(message)
                    }
                @unknown default:
                    print("Default")
                    break
                }
                
            case .failure(let error):
                print("Receive Error: \(error)")
            }
            self?.recieve()
        })
    }
    
//    Calls when Socket Session is Started
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connection Established")
        ping()
        recieve()
    }
    
//    Calls when Socket Session is Ended
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Connection Terminated")
    }
}
