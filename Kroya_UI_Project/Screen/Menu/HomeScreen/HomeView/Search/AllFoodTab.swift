
import SwiftUI

struct AllFoodTab: View {
    @StateObject private var listFood = FoodListVM()
    @StateObject private var favoriteFoodSale = FavoriteVM()
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    var isSelected: Int?
    var foodName: String
    var body: some View {
        VStack(spacing: 10) {
            if listFood.listFoodSell.isEmpty && listFood.listFoodRecipe.isEmpty && !listFood.isLoading {
                Text("No Food Found!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        // Display name sell
                        ForEach(listFood.listFoodSell) { foodsell in
                            NavigationLink(destination: foodDetailDestination(for: foodsell)) {
                                FoodOnSaleViewCell(
                                    foodSale: foodsell,
                                    foodId: foodsell.id,
                                    itemType: "FOOD_SELL",
                                    isFavorite: foodsell.isFavorite ?? false
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Display name recipe
                        ForEach(listFood.listFoodRecipe) { foodrecipe in
                            NavigationLink(destination: recipeDetailDestination(for: foodrecipe)) {
                                RecipeViewCell(
                                    recipe: foodrecipe,
                                    foodId: foodrecipe.id,
                                    itemType: "FOOD_RECIPE",
                                    isFavorite: foodrecipe.isFavorite
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                
                .overlay(
                    Group {
                        if listFood.isLoading {
                            Color.white
                                .edgesIgnoringSafeArea(.all)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                .scaleEffect(2)
                        }
                    }
                )
            }}
                .onAppear {
                    if listFood.listFood.isEmpty || listFood.listFoodRecipe.isEmpty {
                        listFood.searchFoodByName(foodName: foodName)
                    }
        }}
    
    // MARK: - Destination Views
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
            isFavorite: foodSale.isFavorite ?? false,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: foodSale.id,
        ItemType: foodSale.itemType
    )
    }
    
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View {
        FoodDetailView(
            isFavorite: recipe.isFavorite,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: recipe.id,
        ItemType: recipe.itemType
    )
    }
}
