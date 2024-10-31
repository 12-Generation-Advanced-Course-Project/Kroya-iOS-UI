//
//  AllTabView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/15/24.
//

import SwiftUI

struct AllPopularTabView: View {
    
    var isselected : Int?
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            
            VStack{
                // Example PopularDishesCard for dishes
                NavigationLink(destination:
                                FoodDetailView(
                                    theMainImage: "Songvak",
                                    subImage1: "ahmok",
                                    subImage2: "brohok",
                                    subImage3: "SomlorKari",
                                    subImage4: "Songvak",
                                    showPrice: true
                                )
                ) {
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
                
                NavigationLink(destination:
                                FoodDetailView(
                                    theMainImage: "Songvak",
                                    subImage1: "ahmok",
                                    subImage2: "brohok",
                                    subImage3: "SomlorKari",
                                    subImage4: "Songvak",
                                    showOrderButton: false
                                )
                ) {
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

#Preview {
    AllPopularTabView()
}
