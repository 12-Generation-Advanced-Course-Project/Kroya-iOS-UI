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
        VStack{
            ScrollView(.vertical,showsIndicators: false){
                
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
                        
                        imageName: "ahmok3",
                        dishName: "Amok Fish",
                        cookingDate: "30 Sep 2024",
                        price: 3.00,
                        rating: 4.0,
                        reviewCount: 100,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike"
                    )
                }
                
                NavigationLink(destination:   FoodDetailView(
                    theMainImage: "Songvak",
                    subImage1: "ahmok",
                    subImage2: "brohok",
                    subImage3: "SomlorKari",
                    subImage4: "Songvak",
                    showOrderButton: false
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
                
            }   .padding(.horizontal, 20)
        }
       
    }
}

#Preview {
    AllView()
}
