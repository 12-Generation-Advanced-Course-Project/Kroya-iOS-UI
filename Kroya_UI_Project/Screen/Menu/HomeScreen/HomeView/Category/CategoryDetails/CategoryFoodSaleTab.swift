//
//  CategoryFoodSaleTab.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 13/11/24.
//

import SwiftUI

struct CategoryFoodSaleTab: View {
    
    @ObservedObject var categoryVM: CategoryMV
    @StateObject private var favoriteFoodSale = FavoriteVM()
    var body: some View {
        ZStack {
            VStack {
                if categoryVM.FoodSellByCategory.isEmpty && !categoryVM.isLoading {
                    ZStack {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.8) // Adjust opacity for a translucent background
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                            .scaleEffect(2)
                            .offset(y: -50)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(categoryVM.FoodSellByCategory) { foodSale in
                                NavigationLink(destination: foodDetailDestination(for: foodSale)) {
                                    FoodOnSaleViewCell(foodSale: foodSale, onFavoriteToggle: { foodId in
                                        favoriteFoodSale.createFavoriteFood(foodId: foodId, itemType: "FOOD_SELL")
                                    })
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
            theMainImage: "Hotpot",
            subImage1: "Chinese Hotpot",
            subImage2: "Chinese",
            subImage3: "Fly-By-Jing",
            subImage4: "Mixue",
            showOrderButton: foodSale.isOrderable
        )
    }
}
