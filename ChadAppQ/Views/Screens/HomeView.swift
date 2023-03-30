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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.created)]) var questions: FetchedResults<Questions>
    
    var body: some View {
        ZStack {
            VStack {
                if vm.fetchingChats {
                    ProgressView()
                } else {
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
                        .refreshable {
                            vm.loadChats(questions: self.questions, settings: self.settings)
                        }
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: NewChatView(vm: NewChatViewModel(allQuestions: vm.questions)), isActive: $vm.showNewChatView) {
                        ChadFloatingButton(label: "plus", action: {
                            vm.startNewChat(questions: questions)
                        })
                    }
                }
            }
        }.onAppear() {
            vm.setUpApp(questions: self.questions, settings: self.settings)
        }
        .padding()
        .navigationBarTitle("Chats")
        .navigationBarItems(trailing: Button("Logout") {
            vm.showLogoutAlert = true
        })
        .alert("Are you sure you want to logout?", isPresented: $vm.showLogoutAlert) {
            Button("Cancel", role: .cancel){}
            Button("Logout", role: .destructive) {
                vm.logoutUser(settings: settings)
            }
        }
        .alert(vm.textErrorAlert, isPresented: $vm.showErrorAlert) { }
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
