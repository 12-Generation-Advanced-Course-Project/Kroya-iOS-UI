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
            theMainImage: "ahmok",
            subImage1: "ahmok1",
            subImage2: "ahmok2",
            subImage3: "ahmok3",
            subImage4: "ahmok4",
            showOrderButton: foodSale.isOrderable,
            showPrice: foodSale.isOrderable
        )
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
