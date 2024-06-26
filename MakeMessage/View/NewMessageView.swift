//
//  NewMessageView.swift
//  air
//
//  Created by Naoto Sato on 2024/03/24.
//

import SwiftUI

struct NewMessageView: View {
    @State private var searchText = ""
    @State private var viewModel = NewMessageViewModel()
    @Binding var selectetUser: User?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            ScrollView{
                TextField("To: " , text: $searchText)
                    .frame(height: 44)
                    .padding(.leading)
                    .background(Color(.systemGroupedBackground))
                
                Text("Contacts")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .padding()
                
                ForEach(viewModel.users) { user in
                    VStack{
                        
                        HStack{
                            
                            ProfileImageView(user: user, size: .small)
                            
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                        Divider()
                            .padding(.leading,40)
                    
                            .onTapGesture {
                                selectetUser = user
                                dismiss()
                            }
                    }
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        NewMessageView(selectetUser: .constant(User.MOCK_USER))
    }
}
