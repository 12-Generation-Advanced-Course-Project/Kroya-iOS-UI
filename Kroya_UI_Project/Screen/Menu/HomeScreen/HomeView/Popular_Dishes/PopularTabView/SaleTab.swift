//
//  sale.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct PopularSellTab: View {
    var isSelected: Int?
    @StateObject private var popularSell = PopularFoodVM()
    @StateObject private var favoriteFoodSale = FavoriteVM()
  
    var body: some View {
        VStack {
            if popularSell.popularFoodSell.isEmpty && !popularSell.isLoading{
                Text("No Popular Food Sell Found!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(popularSell.popularFoodSell) { popularsell in
                            NavigationLink(destination: foodDetailDestination(for: popularsell)) {
                                FoodOnSaleViewCell(foodSale: popularsell, onFavoriteToggle: { foodId in
                                    favoriteFoodSale.createFavoriteFood(foodId: foodId, itemType: "FOOD_SELL")
                                })
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .overlay(
                    Group {
                        if popularSell.isLoading {
                            Color.white
                                .edgesIgnoringSafeArea(.all)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                .scaleEffect(2)
                        }
                    }
                )
            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if popularSell.popularFoodSell.isEmpty {
                popularSell.getAllPopular()
            }
        }
    }
    
    // MARK: - Food Detail Destination
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
        showPrice: true, // Always false for recipes
        showOrderButton: true, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: foodSale.id ?? 0,
        ItemType: foodSale.itemType
    )
    }
}
