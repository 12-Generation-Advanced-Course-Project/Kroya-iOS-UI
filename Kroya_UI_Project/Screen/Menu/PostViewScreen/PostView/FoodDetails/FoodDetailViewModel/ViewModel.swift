//
//  ViewModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/24/24.
//

import Foundation


struct FoodDetail: Identifiable{
    // Data properties
    let id = UUID()
    let foodName    : String
    let price       : Float
    let date        : String
    let itemFood    : String
    let time        : String
    let imageProfile     : String
    let userName    : String
    let description : String
    let ingredients : String
    let stepDetail : String
    let percentageOfRating: Double
    let numberOfRating: Int
    let review: String
    let reviewDetail: String
}


    let FoodDetails = [
        FoodDetail(foodName: "Songvak", price: 5, date: "12 10 2024", itemFood: "Soup", time: "50", imageProfile: "me", userName: "Sreng Sodane", description: "You can do it!", ingredients: "Sugar", stepDetail: "sdhfhhi", percentageOfRating: 4, numberOfRating: 168, review: "sdjifijo", reviewDetail: "iodsfjidjoi")
  
        
    ]
