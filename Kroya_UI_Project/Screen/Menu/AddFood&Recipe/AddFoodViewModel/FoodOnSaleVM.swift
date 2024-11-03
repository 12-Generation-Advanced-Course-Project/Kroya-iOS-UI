//
//  FoodOnSaleVM.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 1/11/24.
//

import SwiftUI
import Foundation

struct FoodOnSaleModel: Identifiable {

    let id = UUID()
    var imageName           : String
    var dishName            : String
    var cookingDate         : String
    var price               : Double
    var rating              : Double
    var reviewCount         : Int
    var deliveryInfo        : String
    var deliveryIcon        : String
    
}

class FoodOnSaleViewCellViewModel: ObservableObject {
    @Published var foodOnSaleItems: [FoodOnSaleModel] = [
        FoodOnSaleModel(
            imageName: "food1",
            dishName: "Grilled Chicken",
            cookingDate: "01 Nov 2024",
            price: 7.50,
            rating: 4.7,
            reviewCount: 150,
            deliveryInfo: "Free",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food2",
            dishName: "Spring Rolls",
            cookingDate: "02 Nov 2024",
            price: 3.25,
            rating: 4.5,
            reviewCount: 90,
            deliveryInfo: "Free",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food3",
            dishName: "Fried Rice",
            cookingDate: "03 Nov 2024",
            price: 5.00,
            rating: 4.6,
            reviewCount: 200,
            deliveryInfo: "$2",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food4",
            dishName: "Beef Stew",
            cookingDate: "04 Nov 2024",
            price: 8.75,
            rating: 4.8,
            reviewCount: 170,
            deliveryInfo: "Free",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food5",
            dishName: "Vegetable Stir Fry",
            cookingDate: "05 Nov 2024",
            price: 6.00,
            rating: 4.4,
            reviewCount: 110,
            deliveryInfo: "$1",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food6",
            dishName: "Crispy Pork Belly",
            cookingDate: "06 Nov 2024",
            price: 10.00,
            rating: 4.9,
            reviewCount: 220,
            deliveryInfo: "Free",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food7",
            dishName: "Fish Amok",
            cookingDate: "07 Nov 2024",
            price: 8.00,
            rating: 4.7,
            reviewCount: 180,
            deliveryInfo: "$2",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food8",
            dishName: "BBQ Skewers",
            cookingDate: "08 Nov 2024",
            price: 9.00,
            rating: 4.8,
            reviewCount: 210,
            deliveryInfo: "Free",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food9",
            dishName: "Chicken Satay",
            cookingDate: "09 Nov 2024",
            price: 7.00,
            rating: 4.5,
            reviewCount: 130,
            deliveryInfo: "$1.50",
            deliveryIcon: "motorbike"
        ),
        
        FoodOnSaleModel(
            imageName: "food10",
            dishName: "Pad Thai",
            cookingDate: "10 Nov 2024",
            price: 6.50,
            rating: 5.0,
            reviewCount: 300,
            deliveryInfo: "Free",
            deliveryIcon: "motorbike"
        )
    ]
}

