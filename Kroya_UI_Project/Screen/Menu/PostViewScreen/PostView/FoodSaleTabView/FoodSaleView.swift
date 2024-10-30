//
//  FoodSaleView.swift
//  Kroya_UI_Project
//
//  
// 29/10/24
// Hengly
//

import SwiftUI

struct FoodSaleView: View {
    
    //Properties
    var iselected       :Int?
    
    var body: some View {
        
        VStack{
            ScrollView(.vertical,showsIndicators: false){
                
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
                        
                        imageName: "food1",
                        dishName: "Noodles",
                        cookingDate: "30 Sep 2024",
                        price: 2.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike"
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
                    RecipeViewCell(
                        
                        imageName           : "food9",
                        dishName            : "Stack",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
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
                        
                        imageName: "food2",
                        dishName: "Fried fish",
                        cookingDate: "30 Sep 2024",
                        price: 2.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike"
                    )
                }
                .padding(.top, 10)
                
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
                    RecipeViewCell(
                        
                        imageName           : "food3",
                        dishName            : "Koung",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
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
                    RecipeViewCell(
                        
                        imageName           : "food7",
                        dishName            : "BayChar Loklak",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
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
                    RecipeViewCell(
                        
                        imageName           : "food5",
                        dishName            : "Amork",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
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
                    RecipeViewCell(
                        
                        imageName           : "food4",
                        dishName            : "Char Kroeng",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                       
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 10)
        
    }
}

#Preview {
    FoodSaleView()
}




