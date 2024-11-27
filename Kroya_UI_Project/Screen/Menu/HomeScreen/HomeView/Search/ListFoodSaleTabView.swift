

import SwiftUI

// MARK: - FoodOnSaleView
struct ListFoodSaleTabView: View {
    var iSselected: Int?
    @StateObject private var listFoodSale = FoodListVM()
    @StateObject private var favoriteFoodSale = FavoriteVM()
    @StateObject private var guestSearchFoodSale = GuestSearchAllFoodVM()
    var foodName : String
    var guestFoodName : String
    var body: some View {
        VStack {
            if Auth.shared.hasAccessToken(){
                if listFoodSale.listFoodSell.isEmpty && !listFoodSale.isLoading {
                    Text("No Sale Found")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(listFoodSale.listFoodSell) { foodSale in
                                NavigationLink(destination:
                                                FoodDetailView(
                                                    isFavorite: foodSale.isFavorite ?? false, showPrice: true,
                                                    showOrderButton: true,
                                                    showButtonInvoic: nil,
                                                    invoiceAccept: nil,
                                                    FoodId: foodSale.id,
                                                    ItemType: foodSale.itemType
                                                )
                                ) {
                                    FoodOnSaleViewCell(
                                        foodSale: foodSale,
                                        foodId: foodSale.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: foodSale.isFavorite ?? false
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    .overlay(
                        Group {
                            if listFoodSale.isLoading {
                                Color.white
                                    .edgesIgnoringSafeArea(.all)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                    .scaleEffect(2)
                            }
                        }
                    )
                }
            } else {
                if guestSearchFoodSale.guestSearchFoodSell.isEmpty && !guestSearchFoodSale.isloading {
                    Text("No Sale Found")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(guestSearchFoodSale.guestSearchFoodSell) { foodSale in
                                NavigationLink(destination:
                                                FoodDetailView(
                                                    isFavorite: foodSale.isFavorite ?? false, showPrice: true,
                                                    showOrderButton: true,
                                                    showButtonInvoic: nil,
                                                    invoiceAccept: nil,
                                                    FoodId: foodSale.id,
                                                    ItemType: foodSale.itemType
                                                )
                                ) {
                                    FoodOnSaleViewCell(
                                        foodSale: foodSale,
                                        foodId: foodSale.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: foodSale.isFavorite ?? false
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    .overlay(
                        Group {
                            if guestSearchFoodSale.isloading {
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
           
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if Auth.shared.hasAccessToken(){
                if listFoodSale.listFoodSell.isEmpty {
                    listFoodSale.searchFoodByName(foodName: foodName)
                }
            }else{
                if guestSearchFoodSale.guestSearchFoodSell.isEmpty {
                    guestSearchFoodSale.getGuestSearchFoodByName(guestFoodName: guestFoodName)
                }
            }
        }
    }
}
