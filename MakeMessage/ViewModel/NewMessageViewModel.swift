//
//  NewMessageViewModel.swift
//  air
//
//  Created by Naoto Sato on 2024/03/27.
//

import Foundation
import Firebase

class NewMessageViewModel: ObservableObject{
    @Published var users = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter( {$0.id != currentUid} )
    }
}
