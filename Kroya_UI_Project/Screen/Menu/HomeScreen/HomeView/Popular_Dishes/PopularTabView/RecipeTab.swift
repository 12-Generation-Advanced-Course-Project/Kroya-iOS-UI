//
//  recipe.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct RecipeTab: View {
    
    var isselected : Int?
    
    var body: some View {
        
        VStack {
            RecipeView()
        }
        
    }
}

#Preview {
    RecipeTab()
}
