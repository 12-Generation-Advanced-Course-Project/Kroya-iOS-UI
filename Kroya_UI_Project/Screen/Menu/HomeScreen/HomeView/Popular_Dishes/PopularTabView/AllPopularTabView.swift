import SwiftUI

struct AllPopularTabView: View {
    @StateObject private var popularFoodVM = PopularFoodVM() // Use a single ViewModel instance
    @StateObject private var favoriteFoodSale = FavoriteVM()
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    @StateObject private var guestPopularFood = GuestPopularFoodVM()
    var isSelected: Int?
    var body: some View {
        VStack{
            if Auth.shared.hasAccessToken(){
                VStack(spacing: 10) {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            // Display popular sell items
                            ForEach(popularFoodVM.popularFoodSell) { popularsell in
                                NavigationLink(destination: foodDetailDestination(for: popularsell)) {
                                    FoodOnSaleViewCell(
                                        foodSale: popularsell,
                                        foodId: popularsell.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: popularsell.isFavorite ?? false
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            // Display popular recipe items
                            ForEach(popularFoodVM.popularFoodRecipe) { popularrecipe in
                                NavigationLink(destination: recipeDetailDestination(for: popularrecipe)) {
                                    RecipeViewCell(
                                        recipe: popularrecipe,
                                        foodId: popularrecipe.id,
                                        itemType: "FOOD_RECIPE",
                                        isFavorite: popularrecipe.isFavorite ?? false
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    
                    .overlay(
                        Group {
                            if popularFoodVM.isLoading {
                                Color.white
                                    .edgesIgnoringSafeArea(.all)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                    .scaleEffect(2)
                            }
                        }
                    )
                }
            }else{
                VStack(spacing: 10) {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            // Display popular sell items
                            ForEach(guestPopularFood.guestPopularFoodSell) { popularsell in
                                NavigationLink(destination: foodDetailDestination(for: popularsell)) {
                                    FoodOnSaleViewCell(
                                        foodSale: popularsell,
                                        foodId: popularsell.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: popularsell.isFavorite ?? false
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            // Display popular recipe items
                            ForEach(guestPopularFood.guestPopularFoodRecipe) { popularrecipe in
                                NavigationLink(destination: recipeDetailDestination(for: popularrecipe)) {
                                    RecipeViewCell(
                                        recipe: popularrecipe,
                                        foodId: popularrecipe.id,
                                        itemType: "FOOD_RECIPE",
                                        isFavorite: popularrecipe.isFavorite ?? false
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    
                    .overlay(
                        Group {
                            if popularFoodVM.isLoading {
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
        }
        .onAppear {
            if Auth.shared.hasAccessToken(){
                if popularFoodVM.popularFoodSell.isEmpty || popularFoodVM.popularFoodRecipe.isEmpty {
                    self.popularFoodVM.getAllPopular()
                }
            }else{
                if guestPopularFood.guestPopularFoodSell.isEmpty || guestPopularFood.guestPopularFoodRecipe.isEmpty {
                    self.guestPopularFood.getAllGuestPopular()
                }
            }
        }
    }
    
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
            isFavorite: recipe.isFavorite ?? false,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: recipe.id,
        ItemType: recipe.itemType
    )
    }
}
