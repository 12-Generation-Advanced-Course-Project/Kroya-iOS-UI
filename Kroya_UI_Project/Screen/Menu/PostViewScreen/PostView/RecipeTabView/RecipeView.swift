//
//  RecipeView.swift
//  Kroya_UI_Project
//
//
// 29/10/24
// Hengly
//

import SwiftUI

struct RecipeView: View {
    
    // Properties
    var iselected: Int?
    
    var body: some View {
        
        List {
            ForEach(0..<3) { index in
                ZStack {
                    RecipeViewCell(
                        
                        imageName: "slide3",
                        dishName: "Amork \(index + 1)",
                        cookingDate: "30 Sep 2024",
                        statusType: "Recipe",
                        rating: 5.0,
                        reviewCount: 200,
                        level: "Easy"
                    )
                    
                  
                    NavigationLink(destination:
                                    FoodDetailView(
                                        theMainImage: "Songvak",
                                        subImage1: "ahmok",
                                        subImage2: "brohok",
                                        subImage3: "SomlorKari",
                                        subImage4: "Songvak",
                                        showOrderButton: false
                                    )
                    ) {
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
    RecipeView(iselected: 1)
}


