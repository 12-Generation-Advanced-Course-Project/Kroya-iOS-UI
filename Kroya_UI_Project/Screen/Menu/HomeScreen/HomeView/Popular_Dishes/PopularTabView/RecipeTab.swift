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
        ScrollView(.vertical,showsIndicators: false) {
            VStack{
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
                    RecipeViewCell(
                        
                        imageName           : "Songvak",
                        dishName            : "Somlor Kari",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
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
                    RecipeViewCell(
                        
                        imageName           : "Songvak",
                        dishName            : "Somlor Kari",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

//#Preview {
//    RecipeTab()
//}
