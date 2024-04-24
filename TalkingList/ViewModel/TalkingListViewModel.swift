//
//  InboxViewModel.swift
//  air
//
//  Created by Naoto Sato on 2024/03/26.
//

import Foundation
import Combine
import Firebase

class TalkingListViewModel: ObservableObject { //ViewModelを監視対象にする
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>() 
    //配列、購読をキャンセルするときに利用　cancel()メソッドが用意。任意のタイミングで保持しているSubscriptionを破棄できる
    
    init(){ //クラスのインスタンスを生成するときに自動で呼び出されるメソッド
        setupSubscribers()
    }
    
    private func setupSubscribers(){ //イベントを受け取って処理をする側の人間Subscriber
        UserService.shared.$currentUser.sink { [weak self] user in //Subscriberを作成
            self?.currentUser = user
        }.store(in: &cancellables) //AnyCancellable配列に格納
    }
}
