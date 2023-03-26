//
//  NewChatView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import SwiftUI

struct NewChatView: View {
    @EnvironmentObject private var settings: UserSettings
    @StateObject private var vm = NewChatViewModel()
    @FetchRequest(sortDescriptors: []) var questions: FetchedResults<Questions>
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    Text("Welcome to NYE Chat Assistant. \nPlease select an option:")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.gray)
                    Spacer()
                }
                ScrollViewReader { value in
                    ForEach(vm.questions, id: \.id) { question in
                        QuestionRowView(text: question.que, isBot: question.fromBot) {
                            withAnimation(.linear(duration: 0.3)) {
                                vm.continueProcess(question: question)
                            }
                        }.transition(AnyTransition.slide)
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                value.scrollTo(32)
                            }
                        }
                    }
                    HStack {
                        NavigationLink(destination: ChatView(vm: ChatViewModel(chat: vm.chat ?? vm.optionalChat, settings: settings)), isActive: $vm.showChatView) {
                            ChadButton(label: "Contact Support", action: {
                                vm.createChat(settings: self.settings)
                            }, loading: .constant(false))
                        }
                        Spacer()
                    }.id(32)
                }
            }
        }.padding(.horizontal)
            .background(Color("Secondary").ignoresSafeArea())
        .onAppear() {
            vm.showStartingQuestions(allQuestions: self.questions)
        }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
            .environmentObject(UserSettings())
    }
}