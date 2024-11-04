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
    @StateObject private var viewModel = AddNewFoodVM()
    var iselected: Int?
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // Food on Sale Cards
                ForEach(viewModel.allNewFoodAndRecipes.filter { $0.isForSale }.prefix(3)) { foodSale in
                    NavigationLink(destination:
                                    FoodDetailView(
                                        theMainImage:"Hotpot",
                                        subImage1:  "Chinese Hotpot",
                                        subImage2:  "Chinese",
                                        subImage3:  "Fly-By-Jing",
                                        subImage4:  "Mixue",
                                        showOrderButton: true
                                    )) {
                        FoodOnSaleViewCell(foodSale: foodSale)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                    }
                }
            }
            .environmentObject(foodOnSaleViewModel)
            .environmentObject(recipeViewModel)
        }
        .padding(.top, 8)
    }
}

#Preview {
    FoodSaleView()
        .environmentObject(FoodOnSaleViewCellViewModel())
        .environmentObject(RecipeViewModel())
}




