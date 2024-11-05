// New Code
// 29/10/24
// Hengly


import SwiftUI

struct FoodOnSaleView: View {
    
    // Properties
    var iselected: Int?
    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
    
    var body: some View {
        List {
            ForEach(addNewFoodVM.allNewFoodAndRecipes.filter { $0.saleIngredients != nil }) { foodSale in
                ZStack {
                    FoodOnSaleViewCell(foodSale: foodSale)
                    NavigationLink(destination: FoodDetailView(
                        theMainImage:"Hotpot",
                        subImage1: "Chinese Hotpot",
                        subImage2: "Chinese",
                        subImage3: "Fly-By-Jing",
                        subImage4: "Mixue",
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
        .scrollIndicators(.hidden)
        .buttonStyle(PlainButtonStyle())
        .listStyle(.plain)
    }
}
