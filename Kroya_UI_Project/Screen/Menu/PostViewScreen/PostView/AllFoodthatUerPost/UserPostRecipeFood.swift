//
//  UserPostRecipeFood.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/17/24.
//

import SwiftUI

struct UserPostRecipeFood:View {
    @StateObject private var userPostRecipeFood = UserFoodViewModel()
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    var isSelected: Int?
    var body: some View {
        VStack {
            if userPostRecipeFood.isLoading {
                ScrollView{
                    ForEach(0..<10) { _ in
                        FoodOnSaleViewCell(
                            foodSale: .placeholder,
                            foodId: 0,
                            itemType: "FOOD_SELL",
                            isFavorite: false
                        )
                        .redacted(reason: .placeholder)
                        .padding(.horizontal, 20)
                    }
                }
            } else {
                if userPostRecipeFood.userPostRecipeFood.isEmpty && !userPostRecipeFood.isLoading {
                    Text("No Food Recipes Available")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(userPostRecipeFood.userPostRecipeFood) { recipe in
                                NavigationLink(destination: recipeDetailDestination(for: recipe)) {
                                    RecipeViewCell(
                                        recipe: recipe,
                                        foodId: recipe.id,
                                        itemType: "FOOD_RECIPE",
                                        isFavorite: recipe.isFavorite ?? false
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
           
                userPostRecipeFood.getAllUserFood()
            
        }
    }
    
    // Destination setup for FoodDetailView with appropriate images
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View { // Use RecipeModel as parameter type
        FoodDetailView(
        isFavorite: recipe.isFavorite ?? false,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: recipe.id,
        ItemType: recipe.itemType
    )
    }
}
