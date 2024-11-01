

import SwiftUI

struct Recipe: View {
    var iselected:Int?
    var body: some View {
        List {
            ForEach(0..<3) { index in // Loop 3 times
                ZStack {
//                    RecipeViewCell(
//                        
//                        imageName: "somlorKari",
//                        dishName: "Somlor Kari \(index + 1)", // Customize the dish name with index
//                        cookingDate: "30 Sep 2024",
//                        statusType: "Recipe",
//                        rating: 5.0,
//                        reviewCount: 200,
//                        level: "Easy"
//                    )
                    
                    // Place the NavigationLink as a background item, without using the arrow.
                    NavigationLink(destination:
                                    FoodDetailView(
                                        theMainImage: "Songvak",
                                        subImage1: "ahmok",
                                        subImage2: "brohok",
                                        subImage3: "SomlorKari",
                                        subImage4: "Songvak"
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
        .buttonStyle(PlainButtonStyle())
        .listStyle(.plain)
    }
}

#Preview {
    Recipe()
}

//FoodandRecipeCardView(
//    imageName: "SomlorKari",
//    dishName: "Somlor Kari",
//    cookingDate: "30 Sep 2024",
//    price: 2.00,
//    rating: 5.0,
//    reviewCount: 200,
//    deliveryInfo: "Free",
//    deliveryIcon: "motorbike",
//    framewidth:330,
//    frameheight:160,
//    frameWImage:400,
//    frameHImage:135,
//    Spacing:200,
//    offset:-45,
//    isRecipeorFood: true
//)
