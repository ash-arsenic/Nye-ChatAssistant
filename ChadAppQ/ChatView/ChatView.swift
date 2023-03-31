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
                        if vm.messages.count == 0 {
                            Text("No chats yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(height: UIScreen.main.bounds.height*0.8)
                        }
                        ForEach(vm.messages, id: \.id) { message in
                            HStack {
                                MessageCellView(message: message.text, sender: !(message.sender == vm.settings.user.username), created: vm.getTime(message.created), dateSent: vm.getDate(message.created), msgSent: message.messageSent, msgRead: message.messageRead)
                            }.onAppear() {
                                value.scrollTo(12)
                            }
                        }
                        
                        ForEach(vm.unsentMessages, id: \.self) { message in
                            HStack {
                                MessageCellView(message: message, sender: false, created: "", dateSent: "", msgSent: false, msgRead: false)
                            }.onAppear() {
                                value.scrollTo(12)
                            }
                        }
                        
                        VStack{}.id(12)
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
            
            vm.loadMessages()
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
                        .font(.title2.bold())
                        .kerning(2)
                    Text(vm.isTyping ? "typing..." : vm.currentStatus)
                        .foregroundColor(.black.opacity(0.8))
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
