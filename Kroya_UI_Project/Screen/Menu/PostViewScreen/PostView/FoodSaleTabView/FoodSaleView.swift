//
//  FoodSaleView.swift
//  Kroya_UI_Project
//
//
// 29/10/24
// Hengly
//

import SwiftUI

struct FoodSaleView: View {
    
    //Properties
    var iselected       :Int?
    
    var body: some View {
        
        VStack{
            ScrollView(.vertical,showsIndicators: false){
                
                // Example PopularDishesCard for dishes
                NavigationLink(destination: FoodDetailView(
                    
                    theMainImage: "Songvak",
                    subImage1: "ahmok",
                    subImage2: "brohok",
                    subImage3: "somlorKari",
                    subImage4: "Songvak"
                    
                )) {
                    FoodOnSaleViewCell(
                        
                        imageName: "food1",
                        dishName: "Noodles",
                        cookingDate: "30 Sep 2024",
                        price: 2.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike"
                    )
                }
                
                NavigationLink(destination:    FoodDetailView(
                    
                    theMainImage: "Songvak",
                    subImage1: "ahmok",
                    subImage2: "brohok",
                    subImage3: "somlorKari",
                    subImage4: "Songvak"
                    
                )) {
                    RecipeViewCell(
                        
                        imageName           : "food9",
                        dishName            : "Stack",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
                // Example PopularDishesCard for dishes
                NavigationLink(destination:    FoodDetailView(
                    
                    theMainImage: "Songvak",
                    subImage1: "ahmok",
                    subImage2: "brohok",
                    subImage3: "somlorKari",
                    subImage4: "Songvak"
                    
                )) {
                    FoodOnSaleViewCell(
                        
                        imageName: "food2",
                        dishName: "Fried fish",
                        cookingDate: "30 Sep 2024",
                        price: 2.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike"
                    )
                }
                .padding(.top, 10)
                
                NavigationLink(destination:   FoodDetailView(
                    
                    theMainImage: "Songvak",
                    subImage1: "ahmok",
                    subImage2: "brohok",
                    subImage3: "somlorKari",
                    subImage4: "Songvak"
                    
                )) {
                    RecipeViewCell(
                        
                        imageName           : "food3",
                        dishName            : "Koung",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
                NavigationLink(destination:   FoodDetailView(
                    
                    theMainImage: "Songvak",
                    subImage1: "ahmok",
                    subImage2: "brohok",
                    subImage3: "somlorKari",
                    subImage4: "Songvak"
                    
                )) {
                    RecipeViewCell(
                        
                        imageName           : "food7",
                        dishName            : "BayChar Loklak",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
                NavigationLink(destination:   FoodDetailView(
                    
                    theMainImage: "Songvak",
                    subImage1: "ahmok",
                    subImage2: "brohok",
                    subImage3: "somlorKari",
                    subImage4: "Songvak"
                    
                )) {
                    RecipeViewCell(
                        
                        imageName           : "food5",
                        dishName            : "Amork",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
                NavigationLink(destination: FoodDetailView(
                    
                    theMainImage: "Songvak",
                    subImage1: "ahmok",
                    subImage2: "brohok",
                    subImage3: "somlorKari",
                    subImage4: "Songvak"
                    
                )) {
                    RecipeViewCell(
                        
                        imageName           : "food4",
                        dishName            : "Char Kroeng",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
                .padding(.top, 10)
                
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 10)
        
    }
}

#Preview {
    FoodSaleView()
}




