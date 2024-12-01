//
//  UserPostFoodSale.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/16/24.
//
import SwiftUI

struct UserPostFoodSale: View {
    var isSelected: Int?
    @StateObject private var userPostFoodsale = UserFoodViewModel()
   // @StateObject private var foodsellVm = FoodSellViewModel()
    @StateObject private var favoriteFoodSale = FavoriteVM()
    var body: some View {
        VStack {
            if userPostFoodsale.isLoading {
                ScrollView{
                    ForEach(0..<10) { _ in
                        FoodOnSaleViewCell(
                            foodSale: .placeholder, // Placeholder model
                            foodId: 0,
                            itemType: "FOOD_SELL",
                            isFavorite: false
                        )
                        .redacted(reason: .placeholder)
                        .padding(.horizontal, 20)
                    }
                }
            } else {
                if userPostFoodsale.userPostFoodSale.isEmpty && !userPostFoodsale.isLoading {
                    Text("No Food Sale Available")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(userPostFoodsale.userPostFoodSale) { foodSale in
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
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
          
                userPostFoodsale.getAllUserFood()
            
        }
    }
    
    // MARK: - Food Detail Destination
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
        isFavorite: foodSale.isFavorite ?? false,
        showPrice: true, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: foodSale.id,
        ItemType: foodSale.itemType
    )
    }
}
