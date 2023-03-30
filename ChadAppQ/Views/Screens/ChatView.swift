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
            if vm.dataLoaded {
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
                        }.onSubmit {
                            vm.sendMessages()
                        }
                    ChadFloatingButton(label: "paperplane.fill", size: .title3, action: {
                        vm.sendMessages()
                    }, showLoading: !vm.msgSent)
                }.padding(.leading).padding(.vertical, 4).padding(.trailing, 8)
                .background(Color.white)
                .cornerRadius(100)
            } else {
                ProgressView()
            }
        }.padding()
        .background(Color("Secondary"))
        .onAppear() {
            vm.startSocket()
        }
        .onDisappear() {
            vm.closeConnection()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                VStack {
                    Text(vm.chat.title)
                    Text(vm.isTyping ? "typing..." : vm.currentStatus)
                }.frame(width: UIScreen.main.bounds.width)
            }
        }
        .alert(vm.textErrorAlert, isPresented: $vm.showErrorAlert) { }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(vm: ChatViewModel(chat: Chat(id: 1, sender: "wally_ryan", receiever: "rose_byrne", title: "Title", accessKey: "h", lastMessage: "No messages"), settings: UserSettings()))
        }
    }
}
