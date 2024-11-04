// New Code
// 29/10/24
// Hengly


import SwiftUI

struct FoodOnSaleView: View {
    
    // Properties
    var iselected: Int?
    @StateObject private var addFoodVM = AddNewFoodVM()
    
    var body: some View {
        List {
            ForEach(addFoodVM.allNewFoodAndRecipes.filter { $0.saleIngredients != nil }) { foodSale in
                ZStack {
                    FoodOnSaleViewCell(foodSale: foodSale)
                    NavigationLink(destination: FoodDetailView(
                        theMainImage: foodSale.photos.first?.photo ?? "Hotpot",
                        subImage1: foodSale.photos.dropFirst().first?.photo ?? "Chinese Hotpot",
                        subImage2: foodSale.photos.dropFirst(2).first?.photo ?? "Chinese",
                        subImage3: foodSale.photos.dropFirst(3).first?.photo ?? "Fly-By-Jing",
                        subImage4: foodSale.photos.dropFirst(4).first?.photo ?? "Mixue",
                        showOrderButton: foodSale.isForSale
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
