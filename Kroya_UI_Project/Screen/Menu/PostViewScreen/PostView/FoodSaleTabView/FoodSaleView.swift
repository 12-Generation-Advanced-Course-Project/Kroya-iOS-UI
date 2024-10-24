//
//  FoodSaleView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 4/10/24.
//

import SwiftUI

struct FoodSaleView: View {
    
    //Properties
    var iselected       :Int?
    
    var body: some View {
        
        VStack{
            FoodOnSaleView()
            
//            RecipeView()
        }
        
    }
}







//    var body: some View{
//
//        VStack{
//            ScrollView(.vertical,showsIndicators: false){
//
//                Spacer()
//                    .frame(height:10)
//
//                VStack{
//
//                    NavigationLink(destination: ContentOnButtonSheet(
//
//                        foodName: "Somlor Kari",
//                        price: 2.00,
//                        date: "30 Sep 2024",
//                        itemFood: "Somlor Kari",
//                        profile: "profile_image",
//                        userName: "User Name",
//                        description: "Somlor Kari is a traditional Cambodian dish...",
//                        ingredients: "Chicken, Coconut Milk, Curry Paste",
//                        percentageOfRating: 4.8,
//                        numberOfRating: 200,
//                        review: "Delicious dish!",
//                        reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor..."
//
//                    )) {
//
//                        FoodOnSaleViewCell(
//
//                            imageName: "brohok", // Make sure this is the correct image in your assets
//                            dishName: "Somlor Kari",
//                            cookingDate: "30 Sep 2024",
//                            price: 2.00,
//                            rating: 5.0,
//                            reviewCount: 200,
//                            deliveryInfo: "Free",
//                            deliveryIcon: "motorbike"
//                        )
//                    }
//
//                    NavigationLink(destination: ContentOnButtonSheet(
//
//                        foodName: "Songvak",
//                        price: 2.00,
//                        date: "30 Sep 2024",
//                        itemFood: "Songvak",
//                        profile: "profile_image", // Assuming a profile image
//                        userName: "User Name",
//                        description: "Songvak is a delicious dish...",
//                        ingredients: "Pork, Fish Sauce, Spices",
//                        percentageOfRating: 4.7,
//                        numberOfRating: 150,
//                        review: "Fantastic!",
//                        reviewDetail: "The dish was flavorful and aromatic, a great meal..."
//
//                    )) {
//                        RecipeViewCell(
//
//                            imageName           : "somlorKari",
//                            dishName            : "Somlor Kari",
//                            cookingDate         : "30 Sep 2024",
//                            statusType          : "Recipe",
//                            rating              : 5.0,
//                            reviewCount         : 200,
//                            level               : "Easy"
//
//                        )
//                    }
//
//                }
////                .padding()
//            }
//        }
//    }
//}

//#Preview {
//    FoodSaleView()
//}
