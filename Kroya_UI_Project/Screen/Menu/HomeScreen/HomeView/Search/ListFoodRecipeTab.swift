//
//  ListFoodRecipeTab.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/20/24.
//

import Foundation

import SwiftUI

// MARK: - RecipeView
struct ListFoodRecipeTab: View {
    @StateObject private var listFoodRecipe = FoodListVM()
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    var foodName : String
    var iSselected: Int?

    var body: some View {
        VStack {
            if listFoodRecipe.listFoodRecipe.isEmpty && !listFoodRecipe.isLoading {
                Text("No Recipes Found")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(listFoodRecipe.listFoodRecipe) { recipe in
                            NavigationLink(destination: recipeDetailDestination(for: recipe)) {
                                RecipeViewCell(
                                    recipe: recipe,
                                    foodId: recipe.id,
                                    itemType: "FOOD_RECIPE",
                                    isFavorite: recipe.isFavorite
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .overlay(
                    Group {
                        if listFoodRecipe.isLoading {
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
            if listFoodRecipe.listFoodRecipe.isEmpty {
                listFoodRecipe.searchFoodByName(foodName: foodName)
            }
        }
    }

    // MARK: Recipe Detail Destination
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View {
        FoodDetailView(
            isFavorite: recipe.isFavorite,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: recipe.id,
        ItemType: recipe.itemType
    )
    }
}
