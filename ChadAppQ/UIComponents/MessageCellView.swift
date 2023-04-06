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
    var msgSent: Bool
    var msgRead: Bool
    
    var body: some View {
        HStack {
            if !sender { // If the message is sent by the logged in user
                Spacer()
            }
            VStack(alignment: .trailing) {
                Text(message)
                    .fontWeight(.semibold)
                    .foregroundColor(sender ? Color.black : Color.white)
                
                HStack {
                    Text(created)
                    if !sender { // Status of the message. 1. Unsent 2. Sent 3. Read
                        Image(systemName: (msgSent ? (msgRead ? "checkmark.circle.fill" : "checkmark") : "clock"))
                    }
                }.font(.caption2)
                .padding(.top, 0.5).padding(.bottom, 2)
                .foregroundColor(sender ? .gray : .white.opacity(0.6))
            }.padding(.top).padding(.horizontal)
            .background(sender ? Color.white : Color("Primary"))
            .cornerRadius(20, corners: sender ? [.topRight, .bottomLeft, .bottomRight] : [.topLeft, .bottomLeft, .bottomRight])
            .contextMenu { // Showing the date when the message is sent
                Text("Sent on \(dateSent)")
            }
            if sender { // If the message is not sent by the logged in user
                Spacer()
            }
        }
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(message: "Hey there", sender: false, created: "00:00", dateSent: "yyyy-mm-dd", msgSent: true, msgRead: true)
    }
}


extension View { // Used for adding the Corner Radius to the specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape { // Custom shape for applying rounded Shape to the content

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
