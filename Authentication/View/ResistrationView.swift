//
//  ResistrationView.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/14.
//

import SwiftUI

struct ResistrationView: View {
    
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            
            //image
            Image("Logo")
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 80))
                .frame(width: 180, height: 120)
                .padding(.vertical, 32)
            
            
            //form
            VStack(spacing: 24){
                InputView(text: $email,
                          title: "Email Address",
                          placeholeder: "name@example.com")
                .autocapitalization(.none)
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholeder: "Enter your name")
                
                
                InputView(text: $password,
                          title: "Password",
                          placeholeder: "Input your password", isSecureField: true)
                
                ZStack(alignment: .trailing){
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholeder: "Confirm your password", isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }
                        else{
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
                
            }
            
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button{
                Task {
                    try await viewModel.createUser(withEmail: email, password: password,fullname:fullname)
                }
            } label: {
                HStack{
                    Text("SIGN UP")
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
            
            Button{
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                    
                }
                .font(.system(size: 14))
            }
            
            
        }
        
    }
}
//MARK: - AuthenticationFormProtocol
extension ResistrationView: AuthenticationFormProtocol {
    var formisValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 6
        && password == confirmPassword
        && !fullname.isEmpty
    }
}

#Preview {
    ResistrationView()
}
