//
//  ChatViewModel.swift
//  air
//
//  Created by Naoto Sato on 2024/03/31.
//

import Foundation

class ChatViewModel: ObservableObject{
    
    @Published var messageText = ""
    let user: User
    
    init(user: User){
        self.user = user
    }
    
    func sendMessage(){
        MessageService.sendMessage(messageText, toUser: user)
    }
}
