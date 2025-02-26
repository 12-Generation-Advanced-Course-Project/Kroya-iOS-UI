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
    @StateObject private var guestSearchFood = GuestSearchAllFoodVM()
    var foodName : String
    var guestFoodName : String
    var iSselected: Int?

    var body: some View {
        VStack {
            if Auth.shared.hasAccessToken(){
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
                                        isFavorite: recipe.isFavorite ?? false
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
//            else{
//                if guestSearchFood.guestSearchFoodRecipe.isEmpty && !guestSearchFood.isloading {
//                    Text("No Recipes Found")
//                        .font(.title3)
//                        .foregroundColor(.gray)
//                        .padding()
//                } else {
//                    ScrollView(showsIndicators: false) {
//                        LazyVStack(spacing: 8) {
//                            ForEach(guestSearchFood.guestSearchFoodRecipe) { recipe in
//                                NavigationLink(destination: recipeDetailDestination(for: recipe)) {
//                                    RecipeViewCell(
//                                        recipe: recipe,
//                                        foodId: recipe.id,
//                                        itemType: "FOOD_RECIPE",
//                                        isFavorite: recipe.isFavorite ?? false
//                                    )
//                                    .frame(maxWidth: .infinity)
//                                    .padding(.horizontal, 20)
//                                }
//                            }
//                        }
//                    }
//                    .overlay(
//                        Group {
//                            if guestSearchFood.isloading {
//                                Color.white
//                                    .edgesIgnoringSafeArea(.all)
//                                
//                                ProgressView()
//                                    .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
//                                    .scaleEffect(2)
//                            }
//                        }
//                    )
//                }
//            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if Auth.shared.hasAccessToken(){
                if listFoodRecipe.listFoodRecipe.isEmpty {
                    listFoodRecipe.searchFoodByName(foodName: foodName)
                }
            }else{
//                if guestSearchFood.guestSearchFoodRecipe.isEmpty {
//                    guestSearchFood.getGuestSearchFoodByName(guestFoodName: guestFoodName)
//                }
            }
        }
    }

    // MARK: Recipe Detail Destination
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View {
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
