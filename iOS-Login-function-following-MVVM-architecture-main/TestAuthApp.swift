//
//  TestAuthApp.swift
//  TestAuth
//
//  Created by t&a on 2023/03/31.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct TestAuthApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if AuthViewModel.shared.getCurrentUser() != nil {
                    ContentView()
                } else {
                    LoginAuthView()
                }
            }
        }
    }
}
