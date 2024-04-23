//
//  CircularProfileImageView.swift
//  air
//
//  Created by Naoto Sato on 2024/03/24.
//

import SwiftUI

enum ProfileImageSize{
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xlarge
    
    var dimension: CGFloat{
        switch self {
            
            
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 56
        case .large: return 64
        case .xlarge: return 80
        }
    }
}

struct ProfileImageView: View {
    
    var user :User?
    let size: ProfileImageSize
    
    var body: some View {
        if let imageUrl = user?.profileImageUrl{
            Image(imageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .foregroundColor(Color(.systemBlue))
        }
    }
}

#Preview {
    ProfileImageView(user: User.MOCK_USER,size: .medium)
}
