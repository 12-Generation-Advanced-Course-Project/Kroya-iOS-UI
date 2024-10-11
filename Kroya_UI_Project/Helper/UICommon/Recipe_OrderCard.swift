//
//  RecipeFoodCard.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 1/10/24.
//

import SwiftUI

struct Recipe_OrderCard: View {
    // Customizable properties
    var title: String
    var subtitle: String
    var imageName: String
    var backgroundColor: Color = Color(red: 0.999, green: 0.935, blue: 0.694)
    var borderColor: Color = Color(red: 0.952, green: 0.888, blue: 0.656)
    var titleColor: Color = .black
    var subtitleColor: Color = Color(red: 0.4, green: 0.376, blue: 0.279)
    var width: CGFloat
    var height: CGFloat
    var heightImage: CGFloat
    var widthImage: CGFloat
    var xImage:CGFloat
    var yImage:CGFloat
 
    
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
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundColor(titleColor)
                
                Text(subtitle)
                    .font(.customfont(.regular, fontSize: 12))
                    .foregroundColor(subtitleColor)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .padding(.top, 35)
            .offset(y:-10)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: widthImage,height: heightImage)
                .offset(x: xImage, y: yImage)
        }
        .frame(width: width ,height: height)
    }
}

#Preview {
    HStack{
        Recipe_OrderCard(
            title: "Food Order",
            subtitle: "Order what you love",
            imageName: "food_recipe",
            width: .screenWidth * 0.45,
            height: .screenHeight * 0.16,
            heightImage:90,
            widthImage: 120,
            xImage:.screenWidth * 0.09,
            yImage:.screenHeight * 0.028
        )
        Recipe_OrderCard(
            title: "Food Recipe",
            subtitle: "Learn how to cook",
            imageName: "Menu",
            width: .screenWidth * 0.45,
            height: .screenHeight * 0.16,
            heightImage:60,
            widthImage: 85,
            xImage:.screenWidth * 0.1,
            yImage:.screenHeight * 0.04
        )
    }
}
