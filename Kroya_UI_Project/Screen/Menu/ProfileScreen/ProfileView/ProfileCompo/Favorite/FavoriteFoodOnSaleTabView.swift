//
//  FoodOnSaleTabView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/15/24.
//

import SwiftUI

struct FavoriteFoodOnSaleTabView: View {
    @StateObject private var favoriteFoodSale = FavoriteVM()
    
    var body: some View {
        VStack {
            if favoriteFoodSale.favoriteFoodSell.isEmpty && !favoriteFoodSale.isLoading {
                Text("No Favorite Food Sell Found!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(favoriteFoodSale.favoriteFoodSell) { favorite in
                                          FoodOnSaleViewCell(
                                              foodSale: favorite,
                                              isFavorite: favorite.isFavorite,
                                              onFavoriteToggle: { foodId in
                                                  favoriteFoodSale.createFavoriteFood(foodId: foodId, itemType: "FOOD_SELL")
                                              }
                                          )
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                
                .overlay(
                    Group {
                        if favoriteFoodSale.isLoading {
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
            if favoriteFoodSale.favoriteFoodSell.isEmpty {
                favoriteFoodSale.getAllFavoriteFood()
            }
        }
    }
    
    // MARK: - Food Detail Destination
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
            theMainImage: "ahmok",
            subImage1: "ahmok1",
            subImage2: "ahmok2",
            subImage3: "ahmok3",
            subImage4: "ahmok4",
            showOrderButton: true,
            showPrice: true
        )
    }
}
