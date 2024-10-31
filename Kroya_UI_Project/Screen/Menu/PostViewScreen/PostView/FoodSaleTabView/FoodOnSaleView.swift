// New Code
// 29/10/24
// Hengly


import SwiftUI

struct FoodOnSaleView: View {
    
    // Properties
    var iselected: Int?
    
    var body: some View {
        
        List {
            ForEach(0..<3) { index in // Loop 3 times
                ZStack {
                    FoodOnSaleViewCell(
                        imageName: "food7",
                        dishName: "BayChar Loklak",
                        cookingDate: "30 Sep 2024",
                        price: 2.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike"
                    )
                
                    // Place the NavigationLink as a background item, without using the arrow.
                    NavigationLink(destination:
                                    FoodDetailView(
                                        theMainImage: "Songvak",
                                        subImage1: "ahmok",
                                        subImage2: "brohok",
                                        subImage3: "SomlorKari",
                                        subImage4: "Songvak",
                                        showPrice: true
                                    )
                    ) {
                        EmptyView() // Empty view to prevent showing the default arrow
                    }
                    .opacity(0) // Make the navigation link invisible (but still tappable)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden) // Hide separator line for this cell
                .padding(.vertical, -6)
            }
        }
        .scrollIndicators(.hidden)
        .buttonStyle(PlainButtonStyle())
        .listStyle(.plain)
    }
}

#Preview {
    FoodOnSaleView(iselected: 1)
}
