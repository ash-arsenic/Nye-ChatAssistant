//
//  ChadTextField.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 24/03/23.
//

import SwiftUI

struct ChadTextField: View {

    var title: String
    @Binding var text: String
    @Binding var showError: Bool
    
    @FocusState private var showLabel
    @State private var borderColor = Color.gray
    
    var body: some View {
        ZStack {
            TextField(title, text: $text)
                .onChange(of: text, perform: { data in
                    showError = false
                    borderColor = showError ? Color(.red) : Color("Primary")
                })
                .focused($showLabel)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(borderColor, lineWidth: 2)
                }
            
            if showLabel {
                HStack {
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundColor(borderColor)
                        .padding(.horizontal, 5)
                        .background(Color.white)
                    Spacer()
                }
                .padding(.bottom, 50)
                .padding(.leading, 20)
                .onAppear() {
                    withAnimation(.easeIn(duration: 0.35)) {
                        borderColor = showError ? Color.red : Color("Primary")
                    }
                }
                .onDisappear() {
                    withAnimation(.easeOut(duration: 1)) {
                        borderColor = showError ? Color.red : Color.gray
                    }
                }
            }
        }.padding(.bottom, 24)
    }
}

struct ChadTextField_Previews: PreviewProvider {
    static var previews: some View {
        ChadTextField(title: "title", text: .constant(""), showError: .constant(false))
    }
}
