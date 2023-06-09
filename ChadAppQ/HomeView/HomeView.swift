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
                if vm.fetchingChats { // Showed while fetching the data
                    ProgressView()
                } else {
                    if vm.chats.count == 0 { // Showed for newly created User
                        Text("No Chats yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                    } else { // List of Previous Chats. Loads latest Chat on Pull to Refresh
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
            VStack { // Button for starting a new Chat
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: NewChatView(vm: NewChatViewModel(allQuestions: vm.questions)), isActive: $vm.showNewChatView) {
                        ChadFloatingButton(label: "plus", action: {
                            vm.startNewChat(questions: questions)
                        })
                    }
                }
            }.padding()
        }.onAppear() {
            vm.loadChats(questions: self.questions, settings: self.settings)
        }
        .navigationBarTitle("Chats")
        .navigationBarItems(trailing: Button("Logout") { // Logout Button in navigation bar
            vm.showLogoutAlert = true
        }.bold())
        .alert("Are you sure you want to logout?", isPresented: $vm.showLogoutAlert) { // Logout Alert
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
