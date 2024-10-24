//
//  FoodSaleView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 4/10/24.
//

import SwiftUI

struct FoodSaleView: View{
    var iselected:Int?
    var body: some View{
        VStack{
            ScrollView(.vertical,showsIndicators: false){
                Spacer().frame(height:10)
                VStack{
                    NavigationLink(destination: ContentOnButtonSheet(
                               foodName: "Somlor Kari",
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
                                   framewidth:340,
                                   frameheight:210,
                                   frameWImage:405,
                                   frameHImage:180,
                                   Spacing: .screenWidth * 0.55,
                                   offset:.screenHeight * -(0.06)
                               )
                           }
                    
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
                                    imageName: "food_background",
                                    dishName: "Khmer Food",
                                    cookingDate: "30 Sep 2024",
                                    price: 10.00,
                                    rating: 5.0,
                                    reviewCount: 200,
                                    deliveryInfo: "Free",
                                    deliveryIcon: "motorbike",
                                    framewidth:340,
                                    frameheight:210,
                                    frameWImage:405,
                                    frameHImage:180,
                                    Spacing: .screenWidth * 0.55,
                                    offset:.screenHeight * -(0.06)
                                    
                                )
                            }
                   
                }
            }
        }
    }
}

#Preview {
    FoodSaleView()
}
