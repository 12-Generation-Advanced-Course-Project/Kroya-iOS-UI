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
    @StateObject private var guestPopularFood = GuestPopularFoodVM()
    
    var body: some View {
        VStack {
            if Auth.shared.hasAccessToken() {
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
                                    FoodOnSaleViewCell(
                                        foodSale: popularsell,
                                        foodId: popularsell.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: popularsell.isFavorite ?? false
                                    )
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
            }else {
                if guestPopularFood.guestPopularFoodSell.isEmpty && !guestPopularFood.isLoading{
                    Text("No Popular Food Sell Found!")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(guestPopularFood.guestPopularFoodSell) { popularsell in
                                NavigationLink(destination: foodDetailDestination(for: popularsell)) {
                                    FoodOnSaleViewCell(
                                        foodSale: popularsell,
                                        foodId: popularsell.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: popularsell.isFavorite ?? false
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    .overlay(
                        Group {
                            if guestPopularFood.isLoading {
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
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if Auth.shared.hasAccessToken(){
                
                self.popularSell.getAllPopular()
                
            } else{
                
                self.guestPopularFood.getAllGuestPopular()
            }
        }
      
    }
    
    // MARK: - Food Detail Destination
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
            isFavorite: foodSale.isFavorite ?? false,
            showPrice: true, // Always false for recipes
            showOrderButton: true, // Always false for recipes
            showButtonInvoic: nil, // Not applicable
            invoiceAccept: nil, // Not applicable
            FoodId: foodSale.id ?? 0,
            ItemType: foodSale.itemType
    )
    }
}
