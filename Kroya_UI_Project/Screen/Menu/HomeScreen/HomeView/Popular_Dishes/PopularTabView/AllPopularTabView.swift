//
//  AllTabView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/15/24.
//

import SwiftUI

struct AllPopularTabView: View {
    var isselected : Int?
    var body: some View {
        ScrollView() {
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
                frameheight:160,
                frameWImage:400,
                frameHImage:145,
                Spacing:220,
                offset:-41
            )
            PopularDishesCard(
                imageName: "Songvak",
                dishName: "Songvak",
                cookingDate: "30 Sep 2024",
                price: 2.00,
                rating: 5.0,
                reviewCount: 200,
                deliveryInfo: "Free",
                deliveryIcon: "motorbike",
                framewidth:340,
                frameheight:160,
                frameWImage:400,
                frameHImage:145,
                Spacing:220,
                offset:-41
            )
            PopularDishesCard(
                imageName: "brohok",
                dishName: "Brohok",
                cookingDate: "30 Sep 2024",
                price: 2.00,
                rating: 5.0,
                reviewCount: 200,
                deliveryInfo: "Free",
                deliveryIcon: "motorbike",
                framewidth:340,
                frameheight:160,
                frameWImage:400,
                frameHImage:145,
                Spacing:220,
                offset:-41
            )
            PopularDishesCard(
                imageName: "ahmok",
                dishName: "Ahmok",
                cookingDate: "30 Sep 2024",
                price: 2.00,
                rating: 5.0,
                reviewCount: 200,
                deliveryInfo: "Free",
                deliveryIcon: "motorbike",
                framewidth:340,
                frameheight:160,
                frameWImage:400,
                frameHImage:145,
                Spacing:220,
                offset:-41
            )
            
      
     
        }
    }
}

//#Preview {
//    AllPopularTabView()
//}
