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
                    FoodOnSaleViewCell(foodSale: item)  // Pass each item to FoodOnSaleViewCell
                    
                    NavigationLink(destination: FoodDetailView(
                        theMainImage: item.imageName,
                        subImage1: "ahmok",
                        subImage2: "brohok",
                        subImage3: "somlorKari",
                        subImage4: "Songvak"
                    )) {
                        EmptyView()
                    }
                    .opacity(0) // Hide the link arrow
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
