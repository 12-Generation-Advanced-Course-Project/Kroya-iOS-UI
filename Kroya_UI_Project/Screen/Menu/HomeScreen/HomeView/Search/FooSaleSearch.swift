////
////  RecipeSearch.swift
////  Kroya_UI_Project
////
////  Created by Macbook on 11/19/24.
////
//
import SwiftUI

struct FooSaleSearch: View {
    var isSelected: Int?
    @StateObject private var searchFoodsale = SearchVM()
   // @StateObject private var foodsellVm = FoodSellViewModel()
    @StateObject private var favoriteFoodSale = FavoriteVM()
    @State var menuName: String
    var body: some View {
        VStack {
            if searchFoodsale.listFoodSale.isEmpty && !searchFoodsale.isLoading {
                Text("No Food Sale Available")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(searchFoodsale.listFoodSale) { foodSale in
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
                    Group {
                        if searchFoodsale.isLoading {
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
        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            if searchFoodsale.searchFoodSaleName.isEmpty {
//             //   searchFoodsale.getSearchFoodByName(searchText: String)
//            }
       // }
    }
    
    // MARK: - Food Detail Destination
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
        isFavorite: foodSale.isFavorite,
        showPrice: false, // Always false for recipes
        showOrderButton: false, // Always false for recipes
        showButtonInvoic: nil, // Not applicable
        invoiceAccept: nil, // Not applicable
        FoodId: foodSale.id,
        ItemType: foodSale.itemType
    )
    }
}
