import SwiftUI

// MARK: - RecipeView
struct RecipeView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
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
                        ForEach(recipeViewModel.RecipeFood) { recipe in
                            NavigationLink(destination: recipeDetailDestination(for: recipe)) {
                                RecipeViewCell(recipe: recipe)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
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
