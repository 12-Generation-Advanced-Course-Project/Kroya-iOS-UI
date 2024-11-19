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
                                    FoodOnSaleViewCell(
                                        foodSale: foodSale,
                                        foodId: foodSale.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: foodSale.isFavorite
                                    )
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
        isFavorite: foodSale.isFavorite,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: foodSale.id,
        ItemType: foodSale.itemType
    )
    }
}
