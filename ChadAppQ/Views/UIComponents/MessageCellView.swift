//
//  MessageCellView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 25/03/23.
//

import SwiftUI

struct MessageCellView: View {
    var message: String
    var sender: Bool
    var created: String
    var dateSent: String
    
    var body: some View {
        HStack {
            if !sender {
                Spacer()
            }
            VStack(alignment: .trailing) {
                Text(message)
                    .fontWeight(.semibold)
                    .foregroundColor(sender ? Color.black : Color.white)
                Text(created)
                    .padding(.top, 0.5).padding(.bottom, 2)
                    .foregroundColor(sender ? .gray : .white.opacity(0.6))
                    .font(.caption2)
            }.padding(.top).padding(.horizontal)
            .background(sender ? Color.white : Color("Primary"))
            .cornerRadius(20, corners: sender ? [.topRight, .bottomLeft, .bottomRight] : [.topLeft, .bottomLeft, .bottomRight])
            .contextMenu {
                Text("Sent on \(dateSent)")
            }
            if sender {
                Spacer()
            }
        }
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(message: "Hey there", sender: false, created: "00:00", dateSent: "yyyy-mm-dd")
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
