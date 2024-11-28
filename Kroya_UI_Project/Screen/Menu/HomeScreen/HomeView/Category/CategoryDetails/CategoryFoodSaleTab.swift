//
//  CategoryFoodSaleTab.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 13/11/24.
//

import SwiftUI

struct CategoryFoodSaleTab: View {
    
    @ObservedObject var categoryVM: CategoryMV
    @ObservedObject var guestCategoryVM: GuestCategoryVM
    @StateObject private var favoriteFoodSale = FavoriteVM()
    var body: some View {
        if Auth.shared.hasAccessToken(){
            VStack {
                if categoryVM.FoodSellByCategory.isEmpty && !categoryVM.isLoading {
                    ScrollView{
                        ForEach(0..<10) { _ in
                            FoodOnSaleViewCell(
                                foodSale: .placeholder, // Placeholder model
                                foodId: 0,
                                itemType: "FOOD_SELL",
                                isFavorite: false
                            )
                            .redacted(reason: .placeholder)
                        }
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
                                        isFavorite: foodSale.isFavorite ?? false
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
        } else {
            VStack {
                if guestCategoryVM.guestFoodSellByCategory.isEmpty && !guestCategoryVM.isLoading {
                    ForEach(0..<max(1, guestCategoryVM.guestFoodSellByCategory.count)) { _ in
                        FoodOnSaleViewCell(
                            foodSale: .placeholder, // Placeholder model
                            foodId: 0,
                            itemType: "FOOD_SELL",
                            isFavorite: false
                        )
                        .redacted(reason: .placeholder)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(guestCategoryVM.guestFoodSellByCategory) { foodSale in
                                NavigationLink(destination: foodDetailDestination(for: foodSale)) {
                                    FoodOnSaleViewCell(
                                        foodSale: foodSale,
                                        foodId: foodSale.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: foodSale.isFavorite ?? false
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
        isFavorite: foodSale.isFavorite ?? false,
        showPrice: true, // Always false for recipes
        showOrderButton: true, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: foodSale.id,
        ItemType: foodSale.itemType
    )
    }
}
