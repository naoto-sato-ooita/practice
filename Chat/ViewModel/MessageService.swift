//
//  MessageService.swift
//  air
//
//  Created by Naoto Sato on 2024/03/31.
//

import Foundation
import Firebase

struct MessageService {
    
    static let messageCollection = Firestore.firestore().collection("message")
    
    static func sendMessage (_ messageText: String, toUser user: User){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let chatPartnerId = user.id
        
        let currentUserRef = messageCollection.document(currentUid).collection(chatPartnerId).document()
        let chatPartnerRef = messageCollection.document(chatPartnerId).collection(currentUid)
        
        let messageId = currentUserRef.documentID
        
        let message = Message(
            messageId: messageId,
            fromId: currentUid,
            told: chatPartnerId,
            messageText: messageText,
            timeStamp: Timestamp()
        )
        
        guard let messageData = try? Firestore.Encoder().encode(message) else {return}
        
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageId).setData(messageData)
        
        
    }
}
