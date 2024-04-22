//
//  InBoxView.swift
//  air
//
//  Created by Naoto Sato on 2024/03/24.
//

import SwiftUI

struct InBoxView: View {
    
    @State private var showNewMessageView = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser:User?
    @State private var showChat = false
    
    private var user: User?{
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ActiveNowView()
                
                List{
                    ForEach(0...10 , id: \.self){ message in
                        InBoxRowView()
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: UIScreen.main.bounds.height - 120)
            }
            .onChange(of: selectedUser, perform: { newValue in
                showChat  = newValue != nil
            })
            
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            
            .navigationDestination(isPresented: $showChat, destination: {
                if let user = selectedUser{
                    ChatView(user: user)
                }
            } )
            
            .fullScreenCover(isPresented: $showNewMessageView, content: {
                NewMessageView(selectetUser: $selectedUser)
            })
            
            
            .toolbar{
                ToolbarItem(placement:.navigationBarLeading){
                    HStack{
                        NavigationLink(value: user){
                            CircularProfileImageView(user: user, size: .xSmall)
                        }
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement : .navigationBarTrailing){
                    Button{
                        showNewMessageView.toggle()
                        
                    }label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32,height: 32)
                            .foregroundStyle(.black , Color(.systemGray6))
                    }
                    
                }
                
            }
        }
    }
}

#Preview {
    InBoxView()
}
