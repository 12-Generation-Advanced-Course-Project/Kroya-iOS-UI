


import SwiftUI

struct AllUserFoodView:View {
    @StateObject private var popularFoodVM = PopularFoodVM()
    @ObservedObject var ViewAccountUser: ViewaccountViewmodel
    @StateObject private var favoriteFoodVM = FavoriteVM()
    var isSelected: Int?
    var body: some View {
        VStack(spacing: 10) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    // Display popular sell items
                    ForEach(ViewAccountUser.UserFoodDataFoodSell) { userFoodDataFoodSell in
                        NavigationLink(destination: foodDetailDestination(for: userFoodDataFoodSell)) {
                            FoodOnSaleViewCell(foodSale: userFoodDataFoodSell, onFavoriteToggle: { foodId in
                                favoriteFoodVM.createFavoriteFood(foodId: foodId, itemType: "FOOD_SELL")
                            })
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Display popular recipe items
                    ForEach(ViewAccountUser.UserFoodDataRecipe) { userFoodDataRecipe in
                        NavigationLink(destination: recipeDetailDestination(for: userFoodDataRecipe)) {
                            RecipeViewCell(recipe: userFoodDataRecipe, onFavoriteToggle: { foodId in
                                favoriteFoodVM.createFavoriteFood(foodId: foodId, itemType: "FOOD_RECIPE")
                            })
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .overlay(
                Group {
                    if ViewAccountUser.isLoading {
                        ZStack {
                            Color.white
                                .edgesIgnoringSafeArea(.all)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                .scaleEffect(2)
                                .offset(y: -50)
                        }
                    }
                }
            )
        }
        .onAppear {
            
        }
    }
    
    // MARK: - Destination Views
    @ViewBuilder
    private func foodDetailDestination(for userFoodDataFoodSell: FoodSellModel) -> some View {
        FoodDetailView(
        showPrice: true, // Always false for recipes
        showOrderButton: true, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: userFoodDataFoodSell.id,
        ItemType: userFoodDataFoodSell.itemType
    )
    }
    
    @ViewBuilder
    private func recipeDetailDestination(for userFoodDataRecipe: FoodRecipeModel) -> some View {
        FoodDetailView(
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: userFoodDataRecipe.id,
        ItemType: userFoodDataRecipe.itemType
    )
    }
}
