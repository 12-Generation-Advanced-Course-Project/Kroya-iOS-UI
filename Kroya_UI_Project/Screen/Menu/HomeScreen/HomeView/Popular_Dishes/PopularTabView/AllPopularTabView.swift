import SwiftUI

struct AllPopularTabView: View {
    @StateObject private var popularFoodVM = PopularFoodVM() // Use a single ViewModel instance
    var isSelected: Int?
    var body: some View {
        VStack(spacing: 10) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    // Display popular sell items
                    ForEach(popularFoodVM.popularFoodSell) { popularsell in
                        NavigationLink(destination: foodDetailDestination(for: popularsell)) {
                            FoodOnSaleViewCell(foodSale: popularsell)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Display popular recipe items
                    ForEach(popularFoodVM.popularFoodRecipe) { popularrecipe in
                        NavigationLink(destination: recipeDetailDestination(for: popularrecipe)) {
                            RecipeViewCell(recipe: popularrecipe)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .overlay(
                Group {
                    if popularFoodVM.isLoading {
                        LoadingOverlay()
                    }
                }
            )
        }
        .onAppear {
            if popularFoodVM.popularFoodSell.isEmpty || popularFoodVM.popularFoodRecipe.isEmpty {
                popularFoodVM.getAllPopular()
            }
        }
    }
    
    // MARK: - Destination Views
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
        showPrice: true, // Always false for recipes
        showOrderButton: true, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: foodSale.id ?? 0,
        ItemType: foodSale.itemType
    )
    }
    
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View {
        FoodDetailView(
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: recipe.id,
        ItemType: recipe.itemType
    )
    }
}
