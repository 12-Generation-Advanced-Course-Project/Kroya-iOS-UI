//
//  RecipeView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 4/10/24.
//

import SwiftUI

struct RecipeView : View {
    
    //Properties
    var iselected       : Int?
    
    var body: some View {
        
        List {
            RecipeViewCell(
                imageName: "somlorKari", 
                dishName: "Somlor Kari",
                cookingDate: "30 Sep 2024",
                price: 2.00,
                rating: 5.0,
                reviewCount: 200,
                deliveryInfo: "Free",
                deliveryIcon: "motorbike",
                Spacing: 10,
                offset: -45
            )
            .listRowSeparator(.hidden) // Hide separator line for this cell

        }
        .listStyle(.plain)
     
    }
    

}

