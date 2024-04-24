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
    
    //MARK: - 現在ユーザを再確認して、全ユーザ-情報を読み込む
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers() //全ユーザー情報を取り込み
        self.users = users.filter( {$0.id != currentUid} ) //自ユーザーフィルタリング
    }
}
