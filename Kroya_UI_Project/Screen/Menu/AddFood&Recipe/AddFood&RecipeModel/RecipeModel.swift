//
//  RecipeModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 7/11/24.
//

import SwiftUI

struct RecipeModel: Identifiable, Codable {
    var id: Int
    let photo: [Photo]
    let name: String
    let description: String
    let level: String
    let averageRating: Double?
    let totalRaters: Int?
    let isFavorite: Bool
    let itemType: String
    let user: userModel
    
}

