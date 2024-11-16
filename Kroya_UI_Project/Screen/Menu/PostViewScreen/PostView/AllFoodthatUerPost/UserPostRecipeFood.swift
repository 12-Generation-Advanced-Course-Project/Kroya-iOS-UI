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
                                RecipeViewCell(recipe: recipe, onFavoriteToggle: { foodId in
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
                        if userPostRecipeFood.isLoading {
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
            if userPostRecipeFood.userPostRecipeFood.isEmpty {
                userPostRecipeFood.getAllUserFood()
            }
        }
    }
    
    // Destination setup for FoodDetailView with appropriate images
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View { // Use RecipeModel as parameter type
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
