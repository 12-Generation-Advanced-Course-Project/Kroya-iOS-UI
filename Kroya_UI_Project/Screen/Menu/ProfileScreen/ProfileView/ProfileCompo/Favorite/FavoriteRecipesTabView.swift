
import SwiftUI

struct FavoriteRecipesTabView: View {
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    @Binding var searchText : String
    @State private var refreshID = UUID()
    var onFavoritechange: () -> Void
    var body: some View {
        VStack {
            if favoriteFoodRecipe.isLoading {
                ScrollView{
                    ForEach(0..<favoriteFoodRecipe.favoriteFoodRecipe.count) { _ in
                        FoodOnSaleViewCell(
                            foodSale: .placeholder, // Placeholder model
                            foodId: 0,
                            itemType: "FOOD_SELL",
                            isFavorite: false
                        )
                        .redacted(reason: .placeholder)
                        .padding(.horizontal, 20)
                    }
                }
            } else {
                if filteredFoodRecipe.isEmpty{
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
                                    RecipeViewCellForTest(
                                        recipe: favorite,
                                        foodId: favorite.id,
                                        itemType: "FOOD_RECIPE",
                                        isFavorite: favorite.isFavorite ?? false,
                                        onFavoritechange: {
                                          
                                            onFavoritechange()
                                        }
                                    )
                                  
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                   
                                }
                                }
                            }
                        }.id(refreshID)
                }
            }
        }
        
        .padding(.top, 8)
        .onAppear {
                favoriteFoodRecipe.getAllFavoriteFood()
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
    private func removeCardFromList(_ item: FoodRecipeModel) {
        if let index = favoriteFoodRecipe.favoriteFoodRecipe.firstIndex(where: { $0.id == item.id }) {
            favoriteFoodRecipe.favoriteFoodRecipe.remove(at: index)
        }
    }

}
