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
                
                Text(subtitle)
                    .font(.customfont(.light, fontSize: 11))
                    .foregroundColor(subtitleColor)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .padding(.top, 25)
            .offset(y:-10)
        }
        .frame(width: width ,height: height)
    }
}

#Preview {
    HStack{
        UserInfoCardView( title: "Favorite",
                          subtitle: "List of their favorite dishes",
                          width: .screenWidth * 0.45,
                          height: .screenHeight * 0.11
        )
        UserInfoCardView( title: "Addresses",
                          subtitle: "List of your addresses",
                          width: .screenWidth * 0.45,
                          height: .screenHeight * 0.11
        )
    }
    HStack{
        UserInfoCardView( title: "Order",
                          subtitle: "List your order and Sale",
                          width: .screenWidth * 0.45,
                          height: .screenHeight * 0.11
        )
        UserInfoCardView( title: "Sale Reports",
                          subtitle: "List of their favorite dishes",
                          width: .screenWidth * 0.45,
                          height: .screenHeight * 0.11
        )
    }
}

