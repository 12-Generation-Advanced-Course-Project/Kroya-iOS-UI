//
//  sale.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct SaleTab: View {
    var isselected:Int?
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            NavigationLink(destination: ContentOnButtonSheet(
                foodName: "Songvak",
                price: 2.00,
                date: "30 Sep 2024",
                itemFood: "Songvak",
                profile: "profile_image", // Assuming a profile image
                userName: "User Name",
                description: "Songvak is a delicious dish...",
                ingredients: "Pork, Fish Sauce, Spices",
                percentageOfRating: 4.7,
                numberOfRating: 150,
                review: "Fantastic!",
                reviewDetail: "The dish was flavorful and aromatic, a great meal..."
            )) {
                FoodandRecipeCardView(
                    imageName: "Songvak",
                    dishName: "Songvak",
                    cookingDate: "30 Sep 2024",
                    price: 2.00,
                    rating: 5.0,
                    reviewCount: 200,
                    deliveryInfo: "Free",
                    deliveryIcon: "motorbike",
                    framewidth: 340,
                    frameheight: 160,
                    frameWImage: 400,
                    frameHImage: 145,
                    Spacing: 220,
                    offset: -41,
                    isRecipeorFood: true
                )
            }
            NavigationLink(destination: ContentOnButtonSheet(
                foodName: "Somlor Kari",
                price: 2.00,
                date: "30 Sep 2024",
                itemFood: "Somlor Kari",
                profile: "profile_image",
                userName: "Sreng SoDane",
                description: "Somlor Kari is a traditional Cambodian dish",
                ingredients: "Chicken, Coconut Milk, Curry Paste",
                percentageOfRating: 4.8,
                numberOfRating: 200,
                review: "Delicious dish!",
                reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor..."
            )) {
                FoodandRecipeCardView(
                    imageName: "SomlorKari",
                    dishName: "Somlor Kari",
                    cookingDate: "30 Sep 2024",
                    price: 2.00,
                    rating: 5.0,
                    reviewCount: 200,
                    deliveryInfo: "Free",
                    deliveryIcon: "motorbike",
                    framewidth: 340,
                    frameheight: 160,
                    frameWImage: 400,
                    frameHImage: 145,
                    Spacing: 220,
                    offset: -41,
                    isRecipeorFood: true
                )
            }
        }
    }
}

//#Preview {
//   SaleTab()
//}
