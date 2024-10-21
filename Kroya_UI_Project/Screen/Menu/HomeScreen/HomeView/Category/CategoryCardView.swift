//
//  CategoryCardView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 4/10/24.
//

import SwiftUI

struct CategoryCardView: View {
    var title: String
    var image: String
    var color: Color
    var x: CGFloat
    var y: CGFloat

    var body: some View {
        ZStack {
            HStack {
          
                Text(title)
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(.black)
                    .padding(.leading, 25)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                Spacer()
            }
            .frame(width: .screenWidth * 0.4, height: .screenHeight * 0.086)
            // Image positioned independently in the ZStack
            Image(image)
                .resizable()
                .scaledToFit()
                .cornerRadius(13)
                .frame(width: .screenWidth * 0.4, height: .screenHeight * 0.086)
                .offset(x: x, y: y)
                .clipped()
        }
        .background(color)
        .cornerRadius(13)
        .overlay {
            RoundedRectangle(cornerRadius: 13)
                .stroke(Color(hex: "#E6E6E6"), lineWidth: 0.8)
        }
    }
}

#Preview {
    HStack{
        CategoryCardView(title: "Lunch", image: "Somlorkoko", color: .gray, x: 60, y: 18)
        CategoryCardView(title: "Dinner", image: "DinnerPic", color: .gray, x: 50, y: 14)
    }
}

