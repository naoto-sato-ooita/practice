//
//  InboxViewModel.swift
//  air
//
//  Created by Naoto Sato on 2024/03/26.
//

import Foundation
import Combine
import Firebase

class TalkingListViewModel: ObservableObject {
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        setupSubscribers()
    }
    
    private func setupSubscribers(){
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
