import SwiftUI

// MARK: - FoodOnSaleView
struct FoodOnSaleView: View {
    var iselected: Int?
    @StateObject private var foodsellVm = FoodSellViewModel()
    @StateObject private var favoriteFoodSale = FavoriteVM()
    var body: some View {
        VStack {
            if foodsellVm.FoodOnSale.isEmpty && !foodsellVm.isLoading {
                Text("No Food Items Available")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(foodsellVm.FoodOnSale) { foodSale in
                            NavigationLink(destination:
                                            FoodDetailView(
                                                showPrice: true, // Always false for recipes
                                                showOrderButton: true, // Always false for recipes
                                                showButtonInvoic: nil, // Not applicable
                                                invoiceAccept: nil, // Not applicable
                                                FoodId: foodSale.id,
                                                ItemType: foodSale.itemType
                                            )
                                           
                            ) {
                                FoodOnSaleViewCell(foodSale: foodSale, onFavoriteToggle: { foodId in
                                    favoriteFoodSale.createFavoriteFood(foodId: foodId, itemType: "FOOD_SELL")
                                }) .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                    .overlay(
                        Group {
                            if foodsellVm.isLoading {
                                LoadingOverlay()
                            }
                        }
                    )
                }
            }
           
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        
    }
}
