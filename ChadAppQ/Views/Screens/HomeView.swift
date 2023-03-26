//
//  HomeView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var settings: UserSettings
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                if vm.chats.count == 0 {
                    Text("No Chats yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List(vm.chats) { chat in
                        NavigationLink(destination: ChatView(vm: ChatViewModel(chat: chat, settings: settings))) {
                            ChatRowView(title: chat.title, lastMsg: chat.lastMessage)
                        }
                    }.listStyle(.plain)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: NewChatView(), isActive: $vm.showNewChatView) {
                        ChadFloatingButton(label: "plus", action: {
                            vm.showNewChatView = true
                        })
                    }
                }
            }
        }.onAppear(){
            vm.loadChats(settings: self.settings)
        }
        .padding()
        .navigationBarTitle("Chats")
        .navigationBarItems(trailing: Button("Logout") {
            vm.logoutUser(settings: settings)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(UserSettings())
        }
    }
}
