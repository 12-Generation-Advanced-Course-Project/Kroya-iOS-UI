//
//  CategoryFoodRecipeTab.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 13/11/24.
//

import SwiftUI

struct CategoryFoodRecipeTab: View {
    
    @ObservedObject var categoryVM: CategoryMV
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    var body: some View {
        ZStack {
            VStack {
                if categoryVM.FoodRecipByCategory.isEmpty && !categoryVM.isLoading {
                    ZStack {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.8) // Adjust opacity for a translucent background
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                            .scaleEffect(2)
                            .offset(y: -50)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(categoryVM.FoodRecipByCategory) { recipe in
                                NavigationLink(destination: recipeDetailDestination(for: recipe)) {
                                    RecipeViewCell(
                                        recipe: recipe,
                                        foodId: recipe.id ?? 0,
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
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View {
        FoodDetailView(
        isFavorite: recipe.isFavorite ?? false,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: recipe.id ?? 0,
        ItemType: recipe.itemType ?? ""
    )
    }
}
