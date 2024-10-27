//
//  AllView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/21/24.
//

import SwiftUI

struct AllView: View {
    var iselected:Int?
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack{
                FoodandRecipeCardView(
                    imageName: "SomlorKari",
                    dishName: "Somlor Kari",
                    cookingDate: "30 Sep 2024",
                    price: 2.00,
                    rating: 5.0,
                    reviewCount: 200,
                    deliveryInfo: "Free",
                    deliveryIcon: "motorbike",
                    framewidth:330,
                    frameheight:160,
                    frameWImage:400,
                    frameHImage:135,
                    Spacing:200,
                    offset:-45,
                    isRecipeorFood: true
                )
                
                FoodandRecipeCardView(
                    imageName: "SomlorKari",
                    dishName: "Somlor Kari",
                    cookingDate: "30 Sep 2024",
                    price: 2.00,
                    rating: 5.0,
                    reviewCount: 200,
                    deliveryInfo: "Free",
                    deliveryIcon: "motorbike",
                    framewidth:330,
                    frameheight:160,
                    frameWImage:400,
                    frameHImage:135,
                    Spacing:200,
                    offset:-45,
                    isRecipeorFood: true
                )
                FoodandRecipeCardView(
                    imageName: "SomlorKari",
                    dishName: "Somlor Kari",
                    cookingDate: "30 Sep 2024",
                    price: 2.00,
                    rating: 5.0,
                    reviewCount: 200,
                    deliveryInfo: "Free",
                    deliveryIcon: "motorbike",
                    framewidth:330,
                    frameheight:160,
                    frameWImage:400,
                    frameHImage:135,
                    Spacing:200,
                    offset:-45,
                    isRecipeorFood: true
                )
                FoodandRecipeCardView(
                    imageName: "SomlorKari",
                    dishName: "Somlor Kari",
                    cookingDate: "30 Sep 2024",
                    price: 2.00,
                    rating: 5.0,
                    reviewCount: 200,
                    deliveryInfo: "Free",
                    deliveryIcon: "motorbike",
                    framewidth:330,
                    frameheight:160,
                    frameWImage:400,
                    frameHImage:135,
                    Spacing:200,
                    offset:-45,
                    isRecipeorFood: true
                )
            }}
    }
}

#Preview {
    AllView()
}
