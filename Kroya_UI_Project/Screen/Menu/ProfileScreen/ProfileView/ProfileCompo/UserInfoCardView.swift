//
//  UserInfoCardView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/10/24.
//

import SwiftUI

struct UserInfoCardView: View {
    var title: String
    var subtitle: String
    
    var backgroundColor: Color = Color(hex: "#FFFBEB")
    var borderColor: Color = Color(hex: "#F2EEDF")
    var titleColor: Color = .black
    var subtitleColor: Color = Color(red: 0.4, green: 0.376, blue: 0.279)
    var width: CGFloat
    var height: CGFloat
    var isTextCenter: Bool = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: 2)
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(titleColor)
                    .frame(maxWidth:.infinity,alignment: isTextCenter ? .center : .leading)
                
                Text(subtitle)
                    .font(.customfont(.light, fontSize: 11))
                    .foregroundColor(subtitleColor)
                    .frame(maxWidth:.infinity,alignment: isTextCenter ? .center : .leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .padding(.top, isTextCenter ? 35 : 25)
            .offset(y:-10)
        }
        .frame(width: width ,height: height)
    }
}

#Preview {
    HStack{
        UserInfoCardView( title: "Favorite",
                          subtitle: "List of their favorite dishes",
                          width: .screenWidth * 0.44,
                          height: .screenHeight * 0.11
        )
        UserInfoCardView( title: "Addresses",
                          subtitle: "List of your addresses",
                          width: .screenWidth * 0.44,
                          height: .screenHeight * 0.11
        )
    }
    HStack{
        UserInfoCardView( title: "Sale Reports",
                          subtitle: "List of their favorite dishes",
                          width: .screenWidth * 0.9,
                          height: .screenHeight * 0.11
        )
    }
}

