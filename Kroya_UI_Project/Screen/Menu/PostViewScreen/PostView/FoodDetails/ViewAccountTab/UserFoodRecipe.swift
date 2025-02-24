


import SwiftUI

struct UserFoodRecipe:View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @ObservedObject var ViewAccountUser: ViewaccountViewmodel
    var iselected: Int?
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    var body: some View {
        VStack {
            if ViewAccountUser.UserFoodDataRecipe.isEmpty && !ViewAccountUser.isLoading {
                Text("No Recipes Found")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(ViewAccountUser.UserFoodDataRecipe, id: \.id) { recipe in
                            NavigationLink(destination: recipeDetailDestination(for: recipe)) {
                                RecipeViewCell(
                                    recipe: recipe,
                                    foodId: recipe.id,
                                    itemType: "FOOD_RECIPE",
                                    isFavorite: recipe.isFavorite ?? false
                                )
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
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
//            if recipeViewModel.RecipeFood.isEmpty {
//                recipeViewModel.getAllRecipeFood()
//            }
        }
    }

    // MARK: Recipe Detail Destination
    @ViewBuilder
    private func recipeDetailDestination(for recipe: FoodRecipeModel) -> some View {
        FoodDetailView(
            isFavorite: recipe.isFavorite ?? false, showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: recipe.id,
        ItemType: recipe.itemType
    )
    }
}
