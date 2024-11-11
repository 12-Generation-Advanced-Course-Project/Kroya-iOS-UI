//
//  BreakfastRecipeTab.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 8/11/24.
//

import SwiftUI
struct BreakfastRecipeTab:View {
    
    @StateObject private var recipeViewModel = RecipeViewModel() // Correctly initialize the view model
    var iselected: Int?
    var body: some View {
        VStack {
            if recipeViewModel.RecipeFood.isEmpty && !recipeViewModel.isLoading {
                Text("No Recipes Found")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(recipeViewModel.RecipeFood) { recipe in
                            NavigationLink(destination: recipeDetailDestination(for: recipe)) {
                                RecipeViewCell(recipe: recipe)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .overlay(
                    // Show a loading indicator if data is being fetched
                    Group {
                        if recipeViewModel.isLoading {
                            ZStack {
                                Color.white
                                    .edgesIgnoringSafeArea(.all)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                    .scaleEffect(2)
                                    .offset(y:-50)
                            }
                                .padding()
                                
                        }
                    }
                )
            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if recipeViewModel.RecipeFood.isEmpty {
                recipeViewModel.getRecipeFood()
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
