//
//  FavoriteRecipesTabView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/15/24.
//

import SwiftUI

struct FavoriteRecipesTabView: View {
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    
    var body: some View {
        VStack {
            if favoriteFoodRecipe.favoriteFoodRecipe.isEmpty && !favoriteFoodRecipe.isLoading{
                Text("No Favorite Food Recipe Found!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(favoriteFoodRecipe.favoriteFoodRecipe) { favorite in
                            NavigationLink(destination: recipeDetailDestination(for: favorite)) {
                                RecipeViewCell(recipe: favorite)
                                                     .padding(.horizontal)
                                                     .padding(.vertical, 8)
                            }
                        }
                    }
                }
                .overlay(
                    Group {
                        if favoriteFoodRecipe.isLoading {
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
            if favoriteFoodRecipe.favoriteFoodRecipe.isEmpty {
                favoriteFoodRecipe.getAllFavoriteFood()
            }
        }
    }
    // MARK: - Food Detail Destination
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
