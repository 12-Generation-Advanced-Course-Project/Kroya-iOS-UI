//
//  RecipeView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 4/10/24.
//

import SwiftUI

struct RecipeView: View {
    
    // Properties
    var iselected: Int?
    
    var body: some View {
        
        List {
            ForEach(0..<3) { index in // Loop 3 times
                ZStack {
                    RecipeViewCell(
                        
                        imageName: "somlorKari",
                        dishName: "Somlor Kari \(index + 1)", // Customize the dish name with index
                        cookingDate: "30 Sep 2024",
                        statusType: "Recipe",
                        rating: 5.0,
                        reviewCount: 200,
                        level: "Easy"
                    )
                    
                    // Place the NavigationLink as a background item, without using the arrow.
                    NavigationLink(destination: ContentOnButtonSheet(
                        foodName: "Somlor Kari \(index + 1)", // Customize with the index if needed
                        price: 2.00,
                        date: "30 Sep 2024",
                        itemFood: "Somlor Kari",
                        profile: "profile_image",
                        userName: "User Name",
                        description: "Somlor Kari is a traditional Cambodian dish...",
                        ingredients: "Chicken, Coconut Milk, Curry Paste",
                        percentageOfRating: 4.8,
                        numberOfRating: 200,
                        review: "Delicious dish!",
                        reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor..."
                    )) {
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
    RecipeView(iselected: 1)
}


