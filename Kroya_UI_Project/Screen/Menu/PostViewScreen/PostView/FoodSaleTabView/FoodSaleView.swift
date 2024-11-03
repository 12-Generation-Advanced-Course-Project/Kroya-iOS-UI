//
//  FoodSaleView.swift
//  Kroya_UI_Project
//
//
// 29/10/24
// Hengly
//

import SwiftUI

struct FoodSaleView: View {
    
    @StateObject private var foodOnSaleViewModel = FoodOnSaleViewCellViewModel()
    @StateObject private var recipeViewModel = RecipeViewModel()
    var iselected: Int?
    
    var body: some View {
        
        VStack{
            ScrollView(showsIndicators: false){
                // Food on Sale Cards (Limited to 2)
                ForEach(foodOnSaleViewModel.foodOnSaleItems.prefix(3)) { foodSale in
                    NavigationLink(destination:
                                    FoodDetailView(
                                        theMainImage: foodSale.imageName,
                                        subImage1: "ahmok",
                                        subImage2: "brohok",
                                        subImage3: "SomlorKari",
                                        subImage4: foodSale.imageName
                                    )
                    ) {
                        FoodOnSaleViewCell(foodSale: foodSale)
                            .padding(.horizontal, 20)
                            .padding(.bottom,8)
                    }
                }
                
                // Recipe Cards (Limited to 2)
                ForEach(recipeViewModel.recipes.prefix(3)) { recipe in
                    NavigationLink(destination:
                                    FoodDetailView(
                                        theMainImage: recipe.imageName,
                                        subImage1: "ahmok",
                                        subImage2: "brohok",
                                        subImage3: "SomlorKari",
                                        subImage4: recipe.imageName
                                    )
                    ) {
                        RecipeViewCell(recipe: recipe)
                            .padding(.horizontal, 20)
                            .padding(.bottom,8)
                    }
                }
            }
            .environmentObject(foodOnSaleViewModel)
            .environmentObject(recipeViewModel)
        }
        .padding(.top,8)
    }
}

#Preview {
    FoodSaleView()
        .environmentObject(FoodOnSaleViewCellViewModel()) // Injecting sample environment objects for preview
        .environmentObject(RecipeViewModel())
}




