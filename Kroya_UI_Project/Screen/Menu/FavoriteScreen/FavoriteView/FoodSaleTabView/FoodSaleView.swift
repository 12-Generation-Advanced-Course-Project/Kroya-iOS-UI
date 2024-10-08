//
//  FoodSaleView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 4/10/24.
//

import SwiftUI

struct FoodSaleView: View{
    var iselected:Int?
    var body: some View{
        VStack{
            ScrollView(.vertical,showsIndicators: false){
                Spacer().frame(height:10)
                VStack{
                    PopularDishesCard(
                        imageName: "SomlorKari",
                        dishName: "Somlor Kari",
                        cookingDate: "30 Sep 2024",
                        price: 2.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike",
                        framewidth:340,
                        frameheight:200,
                        frameWImage:605,
                        frameHImage:180,
                        Spacing: 235,
                        offset:-60
                    )
                    PopularDishesCard(
                        imageName: "food_background",
                        dishName: "Khmer Food",
                        cookingDate: "30 Sep 2024",
                        price: 10.00,
                        rating: 5.0,
                        reviewCount: 200,
                        deliveryInfo: "Free",
                        deliveryIcon: "motorbike",
                        framewidth:340,
                        frameheight:200,
                        frameWImage:405,
                        frameHImage:180,
                        Spacing: 235,
                        offset:-60
                        
                    )
                }
            }
        }
    }
}

#Preview {
    FoodSaleView()
}
