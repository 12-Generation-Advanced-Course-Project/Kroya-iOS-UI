
import SwiftUI

struct FavoriteFoodOnSaleTabView: View {
    @StateObject private var favoriteFoodSale = FavoriteVM()
    @Binding var searchText: String
    @State private var isFavorite: Bool = false

    var body: some View {
        VStack {
            if favoriteFoodSale.isLoading {
                ScrollView{
                    ForEach(0..<favoriteFoodSale.favoriteFoodSell.count) { _ in
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
                if filteredFoodSell.isEmpty {
                    Text("No Favorite Food Sell Found!")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(filteredFoodSell, id: \.id) { favorite in
                                NavigationLink(destination:
                                    FoodDetailView(
                                        isFavorite: favorite.isFavorite ?? false,
                                        showPrice: false,
                                        showOrderButton: false,
                                        showButtonInvoic: nil,
                                        invoiceAccept: nil,
                                        FoodId: favorite.id,
                                        ItemType: favorite.itemType
                                    )
                                ) {
                                    FoodOnSaleViewCell(
                                        foodSale: favorite,
                                        foodId: favorite.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: favorite.isFavorite ?? isFavorite
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                }
                                .onChange(of: favorite.isFavorite) { newValue in
                                   
                                    if newValue == false {
                                        refreshFavorites()
                                        // Remove the card directly
                                        removeCardFromList(favorite)
                                    }
                                }
                            }
                        }
                    }
                   
                }
            }
        }
        .padding(.top, 8)
        .onAppear {
            // Load favorites when the screen first appears
            refreshFavorites()
        }
    }

    // MARK: - Filtered Results
    private var filteredFoodSell: [FoodSellModel] {
        if searchText.isEmpty {
            return favoriteFoodSale.favoriteFoodSell
        } else {
            return favoriteFoodSale.favoriteFoodSell.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // MARK: - Refresh Favorites
    private func refreshFavorites() {
        favoriteFoodSale.getAllFavoriteFood()
    }

    // MARK: - Remove Card from List
    private func removeCardFromList(_ item: FoodSellModel) {
        // Update the data source to remove the unfavorited item
        if let index = favoriteFoodSale.favoriteFoodSell.firstIndex(where: { $0.id == item.id }) {
            favoriteFoodSale.favoriteFoodSell.remove(at: index)
        }
    }
}
