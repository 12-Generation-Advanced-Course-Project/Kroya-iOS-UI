import SwiftUI

struct RecipeView: View {
    var iselected: Int?
    @EnvironmentObject var viewModel: AddNewFoodVM
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.allNewFoodAndRecipes) { recipe in
                    ZStack {
                        RecipeViewCell(recipe: recipe)
                        NavigationLink(destination: FoodDetailView(
                            theMainImage: recipe.photos.first?.photo ?? "defaultImage",
                            subImage1: recipe.photos.dropFirst().first?.photo ?? "defaultImage",
                            subImage2: recipe.photos.dropFirst(2).first?.photo ?? "defaultImage",
                            subImage3: recipe.photos.dropFirst(3).first?.photo ?? "defaultImage",
                            subImage4: recipe.photos.dropFirst(4).first?.photo ?? "defaultImage",
                            showOrderButton: recipe.isForSale
                        )) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.vertical, -6)
                }
            }
            .onReceive(viewModel.$allNewFoodAndRecipes) { updatedRecipes in
                print("Updated recipes in view:", updatedRecipes)
            }
            .scrollIndicators(.hidden)
            .buttonStyle(PlainButtonStyle())
            .listStyle(.plain)
            .onAppear {
                viewModel.fetchRecipeOrFood(forSaleOnly: false)
                print("Recipes on appear:", viewModel.allNewFoodAndRecipes)
            }
        }
    }
}

