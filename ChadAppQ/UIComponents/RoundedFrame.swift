//
//  RoundedFrame.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 06/04/23.
//

import SwiftUI
// View Builder:- Provide Circular frame to the Content with Light Blue background and dark blue Foreground
struct RoundedFrame<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color("Secondary"))
            .clipShape(Circle())
            .foregroundColor(Color("Primary"))
    }
}

struct RoundedFrame_Previews: PreviewProvider {
    static var previews: some View {
        RoundedFrame {
            Image(systemName: "person")
        }
    }
}
