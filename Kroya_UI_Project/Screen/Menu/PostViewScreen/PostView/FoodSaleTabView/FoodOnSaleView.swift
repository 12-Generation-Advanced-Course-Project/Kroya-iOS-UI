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
                                        subImage4: "Songvak"
                                    )
//                                    ContentOnButtonSheet(
//                        foodName: "Somlor Kari \(index + 1)", // Customize with the index if needed
//                        price: 2.00,
//                        date: "30 Sep 2024",
//                        itemFood: "Somlor Kari",
//                        profile: "profile_image",
//                        userName: "User Name",
//                        description: "Somlor Kari is a traditional Cambodian dish...",
//                        ingredients: "Chicken, Coconut Milk, Curry Paste",
//                        percentageOfRating: 4.8,
//                        numberOfRating: 200,
//                        review: "Delicious dish!",
//                        reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor..."
//                    )
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
