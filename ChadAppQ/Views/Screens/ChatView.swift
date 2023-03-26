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
                            if message.sender == vm.settings.user.username {
                                Spacer()
                            }
                            MessageCellView(message: message.text, sender: !(message.sender == vm.settings.user.username))
                            if message.sender != vm.settings.user.username {
                                Spacer()
                            }
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
        .navigationBarTitle(vm.isTyping ? "typing..." : vm.chat.sender, displayMode: .inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(vm: ChatViewModel(chat: Chat(id: 1, sender: "wally_ryan", receiever: "rose_byrne", title: "Title", accessKey: "h"), settings: UserSettings()))
    }
}
