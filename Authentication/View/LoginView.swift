//
//  LoginIView.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/14.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                //MARK: - icon
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 80))
                    .frame(width: 180, height: 120)
                    .padding(.vertical, 32)


                //MARK: - Form
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeholeder: "name@example.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholeder: "Input your password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                //MARK: - Sign in Button
                
                Button{
                    Task{
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                    
                } label: {
                    HStack{
                        Text("SIGN IN")
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
                
                //MARK: - Sign up
                NavigationLink{
                    ResistrationView()
                        .navigationBarBackButtonHidden(true)
                } label:{
                    HStack{
                        Text("Dont have account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                        
                    }
                    .font(.system(size: 14))
                }
                
                
                
            }
        }
    }
}
//MARK: - AuthenticationFormProtocol
extension LoginView: AuthenticationFormProtocol {
    var formisValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 6
    }
}

#Preview {
    LoginView()
}
