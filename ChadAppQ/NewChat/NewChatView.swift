//
//  NewChatView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import SwiftUI

struct NewChatView: View {
    @EnvironmentObject private var settings: UserSettings
    @ObservedObject var vm: NewChatViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    Text("Welcome to NYE Chat Assistant. \nPlease select an option:")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.black.opacity(0.7))
                    Spacer()
                }
                ScrollViewReader { value in
                    ForEach(vm.questions, id: \.id) { question in // Showing Questions
                        QuestionRowView(text: question.que, isBot: question.fromBot) {
                            withAnimation(.linear(duration: 0.3)) {
                                vm.continueProcess(question: question) // Fetching the children of tapped Row
                            }
                        }.transition(AnyTransition.slide)
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) { // Running it after the animation is complete
                                value.scrollTo(ViewIDs.newChatBottom) // Scolling to the bottom of the Scrollview
                            }
                        }
                    }
                    HStack { // Button for starting new Chat. Always at the bottom of the questions
                        NavigationLink(destination: ChatView(vm: ChatViewModel(chat: vm.chat ?? vm.optionalChat, settings: settings)), isActive: $vm.showChatView) {
                            ChadButton(label: "Contact Support", action: {
                                vm.createChat(settings: self.settings)
                            }, loading: $vm.showLoading)
                        }
                        Spacer()
                    }.id(ViewIDs.newChatBottom)
                }
            }
        }.padding(.horizontal)
        .background(Color("Secondary").ignoresSafeArea())
        .navigationBarTitle("Start New Chat", displayMode: .inline)
        .alert(vm.textErrorAlert, isPresented: $vm.showErrorAlert) { }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView(vm: NewChatViewModel(allQuestions: []))
            .environmentObject(UserSettings())
    }
}
