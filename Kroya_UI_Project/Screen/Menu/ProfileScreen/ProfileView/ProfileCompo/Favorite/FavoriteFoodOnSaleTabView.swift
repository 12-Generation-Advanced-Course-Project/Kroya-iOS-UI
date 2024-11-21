//
//  FoodOnSaleTabView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/15/24.
//

import SwiftUI
struct FavoriteFoodOnSaleTabView: View {
    @StateObject private var favoriteFoodSale = FavoriteVM()
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            if filteredFoodSell.isEmpty && !favoriteFoodSale.isLoading {
                Text("No Favorite Food Sell Found!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredFoodSell) { favorite in
                            NavigationLink(destination:
                                            FoodDetailView(
                                                isFavorite: favorite.isFavorite ?? false,
                                                showPrice: false,
                                                showOrderButton: false,
                                                showButtonInvoic: nil,
                                                invoiceAccept: nil,
                                                FoodId: favorite.id,
                                                ItemType: favorite.itemType
                                            )
                            ) {
                                FoodOnSaleViewCell(
                                    foodSale: favorite,
                                    foodId: favorite.id,
                                    itemType: "FOOD_SELL",
                                    isFavorite: favorite.isFavorite ?? false
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
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
        .onAppear {
            if favoriteFoodSale.favoriteFoodSell.isEmpty {
                favoriteFoodSale.getAllFavoriteFood()
            }
        }
    }
    
    // MARK: - Filtered Results
    private var filteredFoodSell: [FoodSellModel] {
        if searchText.isEmpty {
            return favoriteFoodSale.favoriteFoodSell
        } else {
            return favoriteFoodSale.favoriteFoodSell.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
