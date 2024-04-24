//
//  InBoxView.swift
//  air
//
//  Created by Naoto Sato on 2024/03/24.
//

import SwiftUI

struct TalkingListView: View {
    
    @State private var showNewMessageView = false
    @StateObject var viewModel = TalkingListViewModel()
    @State private var selectedUser:User? //選択したユーザー
    @State private var showChat = false
    
    private var user: User?{
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ActiveNowView() //OnlineのUser表示（不要）
                
                List{
                    ForEach(0...10 , id: \.self){ message in
                        ListBoxView()
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: UIScreen.main.bounds.height - 120)
            }
            .onChange(of: selectedUser, perform: { newValue in
                showChat  = newValue != nil //nilでないならShowchatに格納
            })
            //各ユーザーのプロフィールに遷移？
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            //showchatが押されたらセレクトユーザのチャットViewに遷移？
            .navigationDestination(isPresented: $showChat, destination: {
                if let user = selectedUser { //追加の遷移手段
                    ChatView(user: user)
                }
            } )
            //showNewMessageViewが押されたらセレクトユーザのNewMessageViewに遷移？
            .fullScreenCover(isPresented: $showNewMessageView, content: {
                NewMessageView(selectetUser: $selectedUser)
            })
            
            
            .toolbar{
                ToolbarItem(placement:.navigationBarLeading){//NavagationBarの端に配置
                    HStack{
                        NavigationLink(value: user){
                            ProfileImageView(user: user, size: .xSmall)
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
    TalkingListView()
}
