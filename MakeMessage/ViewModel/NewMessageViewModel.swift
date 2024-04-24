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
    
    //MARK - 現在ユーザを再確認して、全ユーザを読み込む
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter( {$0.id != currentUid} ) //配列内の現在のユーザID以外の全ユーザを抽出usersに格納
    }
}
