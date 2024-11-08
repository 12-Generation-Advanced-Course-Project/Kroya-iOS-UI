//
//  FoodSaleView.swift
//  Kroya_UI_Project
//
//
// 29/10/24
// Hengly
//

import SwiftUI

// MARK: - FoodSaleandRecipeView
struct FoodSaleandRecipeView: View {
    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
    var iselected: Int?

    var body: some View {
        VStack {
            if addNewFoodVM.allNewFoodAndRecipes.isEmpty {
                Text("No Food Items Available")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        // Display Food on Sale items
                        ForEach(addNewFoodVM.allNewFoodAndRecipes.filter { $0.isForSale }.prefix(10)) { foodSale in
                            NavigationLink(destination: foodDetailDestination(for: foodSale)) {
                                FoodOnSaleViewCell(foodCard: FoodSellViewModel())
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // Display Recipe items
                        ForEach(addNewFoodVM.allNewFoodAndRecipes.filter { !$0.isForSale }.prefix(10)) { recipe in
                            NavigationLink(destination: foodDetailDestination(for: recipe)) {
                                RecipeViewCell(recipe: recipe)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
    }
    
    // Destination setup for FoodDetailView with appropriate images and options
    @ViewBuilder
    private func foodDetailDestination(for item: AddNewFoodModel) -> some View {
        FoodDetailView(
            theMainImage:"Mixue",
            subImage1: "Chinese Hotpot",
            subImage2: "Chinese",
            subImage3: "Fly-By-Jing",
            subImage4: "Mixue",
            showOrderButton: item.isForSale,
            showPrice: item.isForSale
        )
    }
}


