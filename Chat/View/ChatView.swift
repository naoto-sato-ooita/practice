//
//  ChatView.swift
//  air
//
//  Created by Naoto Sato on 2024/03/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    let user: User
    
    init(user: User){
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        VStack{
            
            ScrollView{
                
                //header
                VStack{
                    ProfileImageView(user: user, size: .xlarge)
                    
                    VStack(spacing: 4){
                        Text(user.fullname)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Messanger")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                }
                
                //message
                ForEach(0 ... 16 , id: \.self){ message in
                    ChatMessageCell(isFromCurrentUser: Bool.random())
                }
                
            }
            

            //message input View
            
            Spacer()
            
            ZStack(alignment: .trailing) {
                TextField("Message...",text : $viewModel.messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing,48)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                    .font(.subheadline)
                
                Button{
                    viewModel.sendMessage()
                    viewModel.messageText = ""
                } label: {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                
            }
            .padding()
        }
    }
}

#Preview {
    ChatView(user:User.MOCK_USER)
}
