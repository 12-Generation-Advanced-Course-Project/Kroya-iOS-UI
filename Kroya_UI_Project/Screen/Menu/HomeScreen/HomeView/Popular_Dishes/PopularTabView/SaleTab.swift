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
            VStack{
                // Example PopularDishesCard for dishes
                NavigationLink(destination: ContentOnButtonSheet(
                    foodName: "somlor Kari",
                    price: 2.00,
                    date: "30 Sep 2024",
                    itemFood: "Somlor Kari",
                    profile: "profile_image",
                    userName: "User Name",
                    description: "Somlor Kari is a traditional Cambodian dish...",
                    ingredients: "Chicken, Coconut Milk, Curry Paste",
                    percentageOfRating: 4.8,
                    numberOfRating: 200,
                    review: "Delicious dish!",
                    reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor"
                )) {
                    FoodOnSaleViewCell(
                        
                        imageName: "brohok", // Make sure this is the correct image in your assets
                        dishName: "Somlor Kari",
                        cookingDate: "30 Sep 2024",
                        price: 2.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike"
                    )
                }
                
                
                // Example PopularDishesCard for dishes
                NavigationLink(destination: ContentOnButtonSheet(
                    foodName: "somlor Kari",
                    price: 2.00,
                    date: "30 Sep 2024",
                    itemFood: "Somlor Kari",
                    profile: "profile_image",
                    userName: "User Name",
                    description: "Somlor Kari is a traditional Cambodian dish...",
                    ingredients: "Chicken, Coconut Milk, Curry Paste",
                    percentageOfRating: 4.8,
                    numberOfRating: 200,
                    review: "Delicious dish!",
                    reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor"
                )) {
                    FoodOnSaleViewCell(
                        
                        imageName: "brohok", // Make sure this is the correct image in your assets
                        dishName: "Somlor Kari",
                        cookingDate: "30 Sep 2024",
                        price: 2.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike"
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

//#Preview {
//   SaleTab()
//}
