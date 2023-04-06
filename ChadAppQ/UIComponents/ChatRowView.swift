//
//  ChatRowView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 26/03/23.
//

import SwiftUI

struct ChatRowView: View {
    var title: String
    var lastMsg: String
    
    var body: some View {
        HStack {
            RoundedFrame { // ViewBuilder is Used Here
                Image(systemName: HomeImages.images[title] ?? "person.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            }.padding(.trailing, 4)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .kerning(2)
                Text(lastMsg)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
        }
    }
}

struct ChatRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRowView(title: "Chat Title", lastMsg: "Last Message")
    }
}
