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
                                    isFavorite: foodSale.isFavorite
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .overlay(
                    Group {
                        if userPostFoodsale.isLoading {
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
            if userPostFoodsale.userPostFood.isEmpty {
                userPostFoodsale.getAllUserFood()
            }
        }
    }
    
    // MARK: - Food Detail Destination
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
