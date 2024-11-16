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
                            FoodOnSaleViewCell(foodSale: popularsell, onFavoriteToggle: { foodId in
                                favoriteFoodSale.createFavoriteFood(foodId: foodId, itemType: "FOOD_SELL")
                            })
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Display popular recipe items
                    ForEach(allFoodUserPost.userPostRecipeFood) { popularrecipe in
                        NavigationLink(destination: recipeDetailDestination(for: popularrecipe)) {
                            RecipeViewCell(recipe: popularrecipe, onFavoriteToggle: { foodId in
                                favoriteFoodRecipe.createFavoriteFood(foodId: foodId, itemType: "FOOD_RECIPE")
                            })
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
            theMainImage: "ahmok",
            subImage1: "ahmok1",
            subImage2: "ahmok2",
            subImage3: "ahmok3",
            subImage4: "ahmok4",
            showOrderButton: foodSale.isOrderable,
            showPrice: foodSale.isOrderable
        )
    }
    
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View {
        FoodDetailView(
            theMainImage: "Hotpot",
            subImage1: "Chinese Hotpot",
            subImage2: "Chinese",
            subImage3: "Fly-By-Jing",
            subImage4: "Mixue",
            showOrderButton: false
        )
    }
}
