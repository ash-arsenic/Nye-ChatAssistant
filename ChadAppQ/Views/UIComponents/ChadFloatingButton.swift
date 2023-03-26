//
//  ChadFloatingButton.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import SwiftUI

struct ChadFloatingButton: View {
    var label: String
    var size: Font?
    var action: (()->())
    var body: some View {
        Button(action: action, label: {
            Image(systemName: label)
                .font(size ?? .title)
                .bold()
                .padding()
        })
        .background(Color("Primary"))
        .foregroundColor(Color.white)
        .clipShape(Circle())
        .shadow(radius: 4, x: 2, y: 2)
    }
}

struct ChadFloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        ChadFloatingButton(label: "plus", action: {})
    }
}
