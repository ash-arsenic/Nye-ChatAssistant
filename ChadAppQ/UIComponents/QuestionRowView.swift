//
//  QuestionRowView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 26/03/23.
//

import SwiftUI

struct QuestionRowView: View {
    var text: String
    var isBot: Bool
    var action: (()->())
    var body: some View {
        HStack {
            if !isBot { // If the text is not from Bot
                Spacer()
            }
            HStack {
                Button(action: action, label: { // Button with action coming as a parameter to QuestionRowView
                    Text(text).bold()
                })
                .foregroundColor(isBot ? .black.opacity(0.8) : .white)
            }.padding()
                .background(isBot ? .white : Color("Primary"))
            .cornerRadius(8)
            .padding(.horizontal, 4)
            if isBot { // If the text is from Bot
                Spacer()
            }
        }
    }
}

struct QuestionRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionRowView(text: "NYE Prepaid Card", isBot: true){}
    }
}
