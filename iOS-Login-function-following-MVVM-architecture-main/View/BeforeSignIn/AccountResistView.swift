//
//  AccountResistView.swift
//
//
//
//

import SwiftUI

struct AccountResistView: View {
    
    // MARK: - ViewModels
    @ObservedObject var authVM = AuthViewModel.shared
    
    // MARK: - Inputプロパティ
    @State  var name:     String = ""
    @State  var email:    String = ""
    @State  var password: String = ""
    
    // MARK: - Navigationプロパティ
    @State  var isActive: Bool = false
    
    var body: some View {
        VStack{
            
            // MARK: - 透明のNavigationLink
            NavigationLink(isActive: $isActive, destination:{
                ContentView()
            }, label: {
                EmptyView()
            })
            
            // MARK: - エラーメッセージ
            ErrorMessageView()
            
            // MARK: - InputBox
            TextField("ユーザー名", text: $name)
                .padding()
                .textFieldStyle(.roundedBorder)
            
            TextField("メールアドレス", text: $email)
                .padding()
                .textFieldStyle(.roundedBorder)
            
            SecureInputView(password: $password)
            
            // MARK: - ログインボタン
            EmailAuthButtonView(isActive: $isActive, name: name, email: email, password: password)
            
        }.onAppear {
            authVM.resetErrorMsg()
        }
    }
}
struct AccountResistView_Previews: PreviewProvider {
    static var previews: some View {
        AccountResistView()
    }
}
