//
//  User.swift
//  air
//
//  Created by Naoto Sato on 2024/03/24.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable, Hashable{
    @DocumentID var uid: String?
    
    let fullname : String
    let email: String
    let profileImageUrl : String?
    
    var id: String {
        return uid ?? NSUUID().uuidString
    }
    
}

extension User{
    static let MOCK_USER = User(fullname: "testuser", email: "testuser@gmail.com", profileImageUrl: "logo")
}
