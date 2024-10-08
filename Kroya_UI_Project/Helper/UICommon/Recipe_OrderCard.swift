//
//  RecipeFoodCard.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 1/10/24.
//

import SwiftUI

struct RecipeCardView: View {
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
 
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(borderColor, lineWidth: 2)
                )
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.customfont(.bold, fontSize: 24))
                    .foregroundColor(titleColor)
                
                Text(subtitle)
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundColor(subtitleColor)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 35)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .offset(x: 35, y: 55)
        }
        .frame(width: width ,height: height)
    }
}

#Preview {
    RecipeCardView(
        title: "Food Order",
        subtitle: "Order what you love",
        imageName: "food_recipe",
        width: .screenWidth * 0.8,
        height: .screenHeight * 0.24
    )
}
