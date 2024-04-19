//
//  ResetPasswordView.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/15.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email: String = ""
    
    
    var body: some View {
        NavigationStack{
            VStack{
                
                //MARK: - Logo
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 80))
                    .frame(width: 180, height: 120)
                    .padding(.vertical, 32)
                
                
                //MARK: - form
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeholeder: "name@example.com")
                    .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.top, 12)

                //MARK: - SignUp Buttun
                Button{
                    Task {
                        try await viewModel.sendPasswordReset(withEmail: email)
                    }
                } label: {
                    HStack{
                        Text("Send Email")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    
                }
                .background(Color(.systemBlue))
                .disabled(!formisValid)
                .opacity(formisValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top , 24)
                
                Spacer()
            }
        }
    }
}

//MARK: - AuthenticationFormProtocol
extension ResetPasswordView: AuthenticationFormProtocol {
    var formisValid: Bool {
        return !email.isEmpty
        && email.contains("@")
    }
}

#Preview {
    ResetPasswordView()
}
