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
            theMainImage: "Hotpot",
            subImage1: "Chinese Hotpot",
            subImage2: "Chinese",
            subImage3: "Fly-By-Jing",
            subImage4: "Mixue",
            showOrderButton: false
        )
    }
}
