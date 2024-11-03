//
//  RecipeVM.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 1/11/24.
//

import SwiftUI
import Foundation

struct RecipeModal: Identifiable {
    
    let id = UUID()
    var imageName: String
    var dishName: String
    var cookingDate: String
    var statusType: String
    var rating: Double
    var reviewCount: Int
    var level: String
}

class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [RecipeModal] = [
        
        RecipeModal(
            imageName: "food1",
            dishName: "Amork",
            cookingDate: "30 Sep 2024",
            statusType: "Recipe",
            rating: 5.0,
            reviewCount: 200,
            level: "Easy"
        ),
        
        RecipeModal(
            imageName: "food2",
            dishName: "Somlor Kor Ko",
            cookingDate: "01 Oct 2024",
            statusType: "Recipe",
            rating: 4.5,
            reviewCount: 120,
            level: "Medium"
        ),
        
        RecipeModal(
            imageName: "food3",
            dishName: "Num Ansorm",
            cookingDate: "15 Oct 2024",
            statusType: "Recipe",
            rating: 4.8,
            reviewCount: 85,
            level: "Hard"
        ),
        
        RecipeModal(
            imageName: "food4",
            dishName: "Prahok Ktis",
            cookingDate: "20 Oct 2024",
            statusType: "Recipe",
            rating: 4.6,
            reviewCount: 150,
            level: "Medium"
        ),
        
        RecipeModal(
            imageName: "food5",
            dishName: "Samlor Machu Kreung",
            cookingDate: "25 Oct 2024",
            statusType: "Recipe",
            rating: 4.7,
            reviewCount: 130,
            level: "Easy"
        ),
        
        RecipeModal(
            imageName: "food6",
            dishName: "Bai Sach Chrouk",
            cookingDate: "30 Oct 2024",
            statusType: "Recipe",
            rating: 4.9,
            reviewCount: 220,
            level: "Easy"
        ),
        
        RecipeModal(
            imageName: "food7",
            dishName: "Kuy Teav",
            cookingDate: "05 Nov 2024",
            statusType: "Recipe",
            rating: 4.8,
            reviewCount: 180,
            level: "Medium"
        ),
        
        RecipeModal(
            imageName: "food8",
            dishName: "Lok Lak",
            cookingDate: "10 Nov 2024",
            statusType: "Recipe",
            rating: 4.9,
            reviewCount: 250,
            level: "Easy"
        ),
        
        RecipeModal(
            imageName: "food9",
            dishName: "Cha Kdam",
            cookingDate: "15 Nov 2024",
            statusType: "Recipe",
            rating: 4.4,
            reviewCount: 140,
            level: "Hard"
        ),
        
        RecipeModal(
            imageName: "food10",
            dishName: "Nom Banh Chok",
            cookingDate: "20 Nov 2024",
            statusType: "Recipe",
            rating: 5.0,
            reviewCount: 300,
            level: "Medium"
        )
    ]
}
