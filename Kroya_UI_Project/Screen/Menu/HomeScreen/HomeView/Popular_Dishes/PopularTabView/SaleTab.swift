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
                NavigationLink(destination:
                                FoodDetailView(
                                    theMainImage: "Songvak",
                                    subImage1: "ahmok",
                                    subImage2: "brohok",
                                    subImage3: "SomlorKari",
                                    subImage4: "Songvak",
                                    showPrice1: true
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
                
                
                // Example PopularDishesCard for dishes
                NavigationLink(destination:
                                FoodDetailView(
                                    theMainImage: "Songvak",
                                    subImage1: "ahmok",
                                    subImage2: "brohok",
                                    subImage3: "SomlorKari",
                                    subImage4: "Songvak",
                                    showPrice1: true
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
            }
            .padding(.horizontal)
        }
    }
}

//#Preview {
//   SaleTab()
//}
