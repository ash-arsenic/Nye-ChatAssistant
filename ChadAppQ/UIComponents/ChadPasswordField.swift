//
//  ChadPasswordField.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 24/03/23.
//

import SwiftUI

struct ChadPasswordField: View {
    var title: String
    @Binding var text: String
    @Binding var showError: Bool
    
    @FocusState private var showLabel
    @State private var borderColor = Color.gray
    @EyeState private var isSecured // Custom Property Wrapper
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured { // If the Show Password Field is False. Showing the SecureField
                    ChadSecuredField(title: title, text: $text, showError: $showError)
                } else {// If the Show Password Field is True. Showing the TextField
                    ChadTextField(title: title, text: $text, showError: $showError)
                }
            }
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(self.isSecured ? Color.gray : Color("Primary"))
            }.padding().padding(.bottom, 24)
        }
    }
}

struct ChadSecuredField: View {
    var title: String
    @Binding var text: String
    @Binding var showError: Bool
    
    @FocusState private var showLabel
    @State private var borderColor = Color.gray
    
    var body: some View {
        ZStack {
            SecureField(title, text: $text)
                .onChange(of: text, perform: { data in
                    showError = false
                    borderColor = showError ? Color.red : Color("Primary") // Changing border color on writing something in the textfield
                })
                .focused($showLabel)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(borderColor, lineWidth: 2)
                }
            
            if showLabel { // Enabled when the TextField is focused
                HStack {
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundColor(showError ? Color.red : Color("Primary"))
                        .padding(.horizontal, 5)
                        .background(Color.white)
                    Spacer()
                }.padding(.bottom, 50)
                .padding(.leading, 20)
                .onAppear() {
                    withAnimation(.easeOut(duration: 1)) {
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


struct ChadPasswordField_Previews: PreviewProvider {
    static var previews: some View {
        ChadPasswordField(title: "Title", text: .constant(""), showError: .constant(false))
    }
}
