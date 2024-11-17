




import SwiftUI

struct UserFoodSell:View {
    var iselected: Int?
    @StateObject private var foodsellVm = FoodSellViewModel()
    @ObservedObject var ViewAccountUser: ViewaccountViewmodel
    @StateObject private var favoriteFoodVM = FavoriteVM()
    var body: some View {
        VStack {
            if ViewAccountUser.UserFoodDataFoodSell.isEmpty && !ViewAccountUser.isLoading {
                Text("No Food Items Available")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(ViewAccountUser.UserFoodDataFoodSell) { foodSale in
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
                                    favoriteFoodVM.createFavoriteFood(foodId: foodId, itemType: "FOOD_SELL")
                                })
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
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
    }
    
}

