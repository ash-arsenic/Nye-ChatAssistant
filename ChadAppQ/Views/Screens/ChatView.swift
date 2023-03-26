//
//  ChatView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var vm: ChatViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    ForEach(vm.messages, id: \.id) { message in
                        HStack {
                            MessageCellView(message: message.text, sender: !(message.sender == vm.settings.user.username), created: vm.getTime(message.created), dateSent: vm.getDate(message.created))
                        }.onAppear() {
                            value.scrollTo(vm.messages[vm.messages.count - 1].id)
                        }
                    }
                }
            }
            HStack {
                TextField("Enter something", text: $vm.enteredMessage)
                    .onChange(of: vm.enteredMessage) { data in
                        vm.showTyping()
                    }
                    .onSubmit {
                        vm.sendMessages()
                    }
                ChadFloatingButton(label: "paperplane.fill", size: .title3, action: {
                    vm.sendMessages()
                })
            }.padding(.leading).padding(.vertical, 4).padding(.trailing, 8)
            .background(Color.white)
            .cornerRadius(100)
        }.padding()
        .background(Color("Secondary"))
        .onAppear() {
            vm.startSocket()
        }
        .onDisappear() {
            vm.closeConnection()
        }
        .navigationBarTitle(vm.isTyping ? "typing..." : vm.chat.title, displayMode: .inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(vm: ChatViewModel(chat: Chat(id: 1, sender: "wally_ryan", receiever: "rose_byrne", title: "Title", accessKey: "h", lastMessage: "No messages"), settings: UserSettings()))
    }
}
