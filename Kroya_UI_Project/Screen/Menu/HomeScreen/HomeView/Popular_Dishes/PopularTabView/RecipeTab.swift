//
//  recipe.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct RecipeTab: View {
    var isselected : Int?
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            VStack{
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
                        
                        imageName           : "Songvak",
                        dishName            : "Somlor Kari",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
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
                        
                        imageName           : "Songvak",
                        dishName            : "Somlor Kari",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

//#Preview {
//    RecipeTab()
//}
