
import SwiftUI

struct FavoriteRecipesTabView: View {
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    @Binding var searchText : String
    var body: some View {
        VStack {
            if filteredFoodRecipe.isEmpty && !favoriteFoodRecipe.isLoading{
                Text("No Favorite Food Recipe Found!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredFoodRecipe) { favorite in
                            NavigationLink(destination:
                                            FoodDetailView(
                                                isFavorite: favorite.isFavorite ?? false , showPrice: false,
                                                showOrderButton: false,
                                                showButtonInvoic: nil,
                                                invoiceAccept: nil,
                                                FoodId: favorite.id,
                                                ItemType: favorite.itemType
                                            )
                            ) {
                                RecipeViewCell(
                                    recipe: favorite,
                                    foodId: favorite.id,
                                    itemType: "FOOD_RECIPE",
                                    isFavorite: favorite.isFavorite ?? false
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                               
                            }
                               
                            }
                        }
                    }
                .overlay(
                    Group {
                        if favoriteFoodRecipe.isLoading {
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
        .padding(.top, 8)
        .onAppear {
            if favoriteFoodRecipe.favoriteFoodRecipe.isEmpty {
                favoriteFoodRecipe.getAllFavoriteFood()
            }
        }
    }
    // MARK: - Filtered Results
    private var filteredFoodRecipe: [FoodRecipeModel]{
        if searchText.isEmpty {
            return favoriteFoodRecipe.favoriteFoodRecipe
        } else {
            return favoriteFoodRecipe.favoriteFoodRecipe.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
