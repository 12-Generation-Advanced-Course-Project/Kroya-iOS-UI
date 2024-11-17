import SwiftUI

// MARK: - RecipeView
struct RecipeView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
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
                        ForEach(recipeViewModel.RecipeFood, id: \.id) { recipe in
                            NavigationLink(destination: recipeDetailDestination(for: recipe)) {
                                RecipeViewCell(recipe: recipe, onFavoriteToggle: { foodId in
                                    favoriteFoodRecipe.createFavoriteFood(foodId: foodId, itemType: "FOOD_RECIPE")
                                })
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    print("Recipe ID: \(recipe.id)")
                                    print("Item Type: \(recipe.itemType)")
                                }
                            )
                        }
                    }
                }
                .overlay(
                    Group {
                        if recipeViewModel.isLoading {
                            LoadingOverlay()
                        }
                    }
                )
            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if recipeViewModel.RecipeFood.isEmpty {
                recipeViewModel.getAllRecipeFood()
            }
        }
    }

    // MARK: Recipe Detail Destination
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
