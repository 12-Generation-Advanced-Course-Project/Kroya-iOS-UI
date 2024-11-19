//
//  AllUerPostFood.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/17/24.
//

import SwiftUI

struct AllUerPostFood: View {
    @StateObject private var allFoodUserPost = UserFoodViewModel()// Use a single ViewModel instance
    @StateObject private var favoriteFoodSale = FavoriteVM()
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    var isSelected: Int?
    var body: some View {
        VStack(spacing: 10) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    // Display popular sell items
                    ForEach(allFoodUserPost.userPostFoodSale) { popularsell in
                        NavigationLink(destination: foodDetailDestination(for: popularsell)) {
                            FoodOnSaleViewCell(
                                foodSale: popularsell,
                                foodId: popularsell.id,
                                itemType: "FOOD_SELL",
                                isFavorite: popularsell.isFavorite
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // Display popular recipe items
                    ForEach(allFoodUserPost.userPostRecipeFood) { popularrecipe in
                        NavigationLink(destination: recipeDetailDestination(for: popularrecipe)) {
                            RecipeViewCell(
                                recipe: popularrecipe,
                                foodId: popularrecipe.id,
                                itemType: "FOOD_RECIPE",
                                isFavorite: popularrecipe.isFavorite ?? false
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            
            .overlay(
                Group {
                    if allFoodUserPost.isLoading {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                            .scaleEffect(2)
                    }
                }
            )
        }
        .onAppear {
            if allFoodUserPost.userPostFoodSale.isEmpty || allFoodUserPost.userPostRecipeFood.isEmpty {
                allFoodUserPost.getAllUserFood()
            }
        }
    }
    
    // MARK: - Destination Views
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
            isFavorite: foodSale.isFavorite,
            showPrice: true, // Always false for recipes
            showOrderButton: true, // Always false for recipes
            showButtonInvoic: nil, // Not applicable
            invoiceAccept: nil, // Not applicable
            FoodId: foodSale.id,
            ItemType: foodSale.itemType
        )
    }
    
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View {
        FoodDetailView(
        isFavorite: recipe.isFavorite,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: recipe.id ,
        ItemType: recipe.itemType
    )
    }
}
