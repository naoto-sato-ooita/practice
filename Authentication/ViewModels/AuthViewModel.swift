//
//  AuthViewModel.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/14.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formisValid: Bool { get }
}


@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            //await fetchUser()
        }
        catch{
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
        
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //login session
            self.userSession = result.user // if success, store user Session
            let user = User(id: result.user.uid, fullname: fullname, email: email) //to store the uid user info
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) //upload the data for firestore
            
            await fetchUser()
        }
        catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }
        catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func sendPasswordReset(withEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        }
        catch{
            print("DEBUG: Failed to send a email")
        }
        
    }
    
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current user is \(String(describing: self.currentUser))")
    }
    
}
