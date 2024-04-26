//
//  EntitlementManager.swift
//  Step10
//
//  Created by Josh Holtz on 9/19/22.
//

import SwiftUI
//購入情報をエクステンションと共有する
class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.your.app")!

    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
