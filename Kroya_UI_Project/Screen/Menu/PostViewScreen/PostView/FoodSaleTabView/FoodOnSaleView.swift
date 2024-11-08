// New Code
// 29/10/24
// Hengly


import SwiftUI

struct FoodOnSaleView: View {
    
    // Properties
    var iselected: Int?
    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
    @StateObject private var foodsellVm = FoodSellViewModel()
    var body: some View {
        List {
            ForEach(addNewFoodVM.allNewFoodAndRecipes.filter { $0.saleIngredients != nil }) { foodSale in
                ZStack {
                   // FoodOnSaleViewCell(foodSale: foodSale)
                    NavigationLink(destination: FoodDetailView(
                        theMainImage:"ahmok",
                        subImage1: "ahmok1",
                        subImage2: "ahmok2",
                        subImage3: "ahmok3",
                        subImage4: "ahmok4",
                        showOrderButton: foodSale.isForSale,
                        showPrice: foodSale.isForSale
                        
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
        .onAppear{
            foodsellVm.getAllFoodSell()
        }
        .scrollIndicators(.hidden)
        .buttonStyle(PlainButtonStyle())
        .listStyle(.plain)
    }
}
