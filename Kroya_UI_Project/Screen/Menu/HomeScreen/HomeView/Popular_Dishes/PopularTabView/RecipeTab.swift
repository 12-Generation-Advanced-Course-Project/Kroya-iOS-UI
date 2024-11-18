//
//  recipe.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI


struct PopularRecipeTab: View {
    @StateObject private var popularRecipe = PopularFoodVM()
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    var isSelected: Int?
    var body: some View {
        VStack {
            if popularRecipe.popularFoodRecipe.isEmpty && !popularRecipe.isLoading {
                Text("No Popular Recipes Found!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(popularRecipe.popularFoodRecipe) { popularrecipe in
                            NavigationLink(destination: recipeDetailDestination(for: popularrecipe)) {
                                RecipeViewCell(
                                    recipe: popularrecipe,
                                    foodId: popularrecipe.id,
                                    itemType: "FOOD_RECIPE",
                                    isFavorite: popularrecipe.isFavorite
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .overlay(
                    Group {
                        if popularRecipe.isLoading {
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
            if popularRecipe.popularFoodRecipe.isEmpty {
                popularRecipe.getAllPopular()
            }
        }
    }
    
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
