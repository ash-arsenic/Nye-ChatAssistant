//
//  ChadButton.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import SwiftUI

struct ChadButton: View {
    let label: String
    let action: (()->())
    @Binding var loading: Bool
    
    var body: some View {
        Button(action: action, label: {
            if loading {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width * 0.6)
            } else {
                Text(label)
                    .frame(width: UIScreen.main.bounds.width * 0.6)
            }
        }).padding()
            .foregroundColor(Color.white)
            .background(Color("Primary"))
            .cornerRadius(12)
            .shadow(radius: 4, x: 4, y: 4)
            .disabled(loading)
    }
}

struct ChadButton_Previews: PreviewProvider {
    static var previews: some View {
        ChadButton(label: "Button", action: {
            print("Siiiuuuuu")
        }, loading: .constant(false))
    }
}
