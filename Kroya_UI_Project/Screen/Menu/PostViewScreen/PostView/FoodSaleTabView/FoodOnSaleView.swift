// New Code
// 29/10/24
// Hengly


import SwiftUI

struct FoodOnSaleView: View {
    
    // Properties
    var iselected: Int?
    @StateObject private var viewModel = FoodOnSaleViewCellViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.foodOnSaleItems) { item in
                ZStack {
                    FoodOnSaleViewCell(foodSale: item)
                    
                    NavigationLink(destination: FoodDetailView(
                        theMainImage: item.imageName,
                        subImage1: "ahmok",
                        subImage2: "brohok",
                        subImage3: "SomlorKari",
                        subImage4: "Songvak",
                        showPrice: true
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

#Preview {
    FoodOnSaleView()
}
