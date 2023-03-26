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
    
    func setupConnection(chatId: String, chatAccessKey: String, completionHandler: @escaping ((String)->())) {
        self.completionHandler = completionHandler
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "wss://api.chatengine.io/chat/?projectID=\(Keys.projectID)&chatID=\(chatId)&accessKey=\(chatAccessKey)")
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
    }
    
    func ping() {
        webSocket?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Ping error: \(error)")
            }
        })
    }
    
    func close() {
        webSocket?.cancel(with: .goingAway, reason: "Gone".data(using: .utf8))
    }
    
    func send() {
        webSocket?.send(.string("Message from Ashish"), completionHandler: { error in
            if let error = error {
                print("Send error: \(error)")
            } else {
                print("Msg sent successfully")
            }
        })
    }
    
    func recieve() {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case .string(let message):
                    self!.completionHandler!(message)
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
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connection Established")
        ping()
        recieve()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Connection Terminated")
    }
}
