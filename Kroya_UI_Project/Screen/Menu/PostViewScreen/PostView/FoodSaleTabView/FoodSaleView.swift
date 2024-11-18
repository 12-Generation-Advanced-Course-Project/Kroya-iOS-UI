import SwiftUI

// MARK: - FoodSaleandRecipeView
struct FoodSaleandRecipeView: View {
    
    @StateObject private var foodViewModel = FoodSellViewModel()
    var iselected: Int?
    @StateObject private var favoriteFoodSale = FavoriteVM()
    var body: some View {
        VStack {
            if foodViewModel.FoodOnSale.isEmpty && !foodViewModel.isLoading {
                Text(LocalizedStringKey("No Food Items Available"))
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(foodViewModel.FoodOnSale) { foodSale in
                            NavigationLink(destination: foodDetailDestination(for: foodSale)) {
                                FoodOnSaleViewCell(
                                    foodSale: foodSale,
                                    foodId: foodSale.id,
                                    itemType: "FOOD_SELL",
                                    isFavorite: foodSale.isFavorite
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .overlay(
                    // Show a loading indicator if data is being fetched
                    Group {
                        if foodViewModel.isLoading {
                            ZStack {
                                Color.white
                                    .edgesIgnoringSafeArea(.all)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                    .scaleEffect(2)
                                    .offset(y: -50)
                            }
                            .padding()
                        }
                    }
                )
            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if foodViewModel.FoodOnSale.isEmpty {
                foodViewModel.getAllFoodSell()
            }
        }
    }
    
    // Destination setup for FoodDetailView with appropriate images and options
    @ViewBuilder
    private func foodDetailDestination(for item: FoodSellModel) -> some View {
        FoodDetailView(
            isFavorite: item.isFavorite,
            showPrice: false, // Always false for recipes
            showOrderButton: false, // Always false for recipes
            showButtonInvoic: nil, // Not applicable
            invoiceAccept: nil, // Not applicable
            FoodId: item.id ?? 0,
            ItemType: item.itemType
        )
    }
}
