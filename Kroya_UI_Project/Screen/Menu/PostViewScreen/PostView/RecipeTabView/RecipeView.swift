import SwiftUI

// MARK: - RecipeView
struct RecipeView: View {
    @EnvironmentObject var viewModel: AddNewFoodVM
    var iselected: Int?
    var body: some View {
        VStack {
            if viewModel.allNewFoodAndRecipes.isEmpty {
                Text("No Recipes Found")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.allNewFoodAndRecipes.filter { !$0.isForSale }) { recipe in
                            NavigationLink(destination: recipeDetailDestination(for: recipe)) {
                                RecipeViewCell(recipe: recipe)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            if viewModel.allNewFoodAndRecipes.isEmpty {
//                print("Using static recipes:", viewModel.allNewFoodAndRecipes)
//            }
//        }
    }
    
    // Destination setup for FoodDetailView with appropriate images
    @ViewBuilder
    private func recipeDetailDestination(for item: AddNewFoodModel) -> some View {
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
