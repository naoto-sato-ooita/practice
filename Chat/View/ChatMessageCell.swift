//
//  ChatMessageCell.swift
//  air
//
//  Created by Naoto Sato on 2024/03/24.
//

import SwiftUI

struct ChatMessageCell: View {
    let isFromCurrentUser : Bool
    
    var body: some View {
        HStack{
            if isFromCurrentUser{
                Spacer()
                
                Text("This is a test message for now")
                    .font(.subheadline)
                    .padding()
                    .background(Color(red: 0.0, green: 0.78, blue: 0.75, opacity: 1.0))
                    .foregroundColor(.white)
                    .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5 , alignment: .trailing)
            } 
            
            else{
                HStack(alignment: .bottom, spacing: 8){
                    ProfileImageView(user: .MOCK_USER, size: .xxSmall)
                    Text("This is atest message for now")
                        .font(.subheadline)
                        .padding()
                        .background(Color(red: 1.0, green: 0.4, blue: 0.7, opacity: 1.0))
                        .foregroundColor(.white)
                        .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.75 , alignment: .leading)

                    
                    Spacer()
                    
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    ChatMessageCell(isFromCurrentUser: true)
}
