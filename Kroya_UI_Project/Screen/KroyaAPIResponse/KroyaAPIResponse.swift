//
//  KroyaAPIResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 24/10/24.
//

import Foundation
import SwiftUI

// Generic API response model
struct KroyaAPIResponse<T: Decodable>: Decodable {
    let message: String
    let payload: [T]?
    let statusCode: String
    let timestamp: String?
}
//MARK: User Setting Profile
typealias UserSettingProfileResponse = KroyaAPIResponse<ProfileModel>
typealias foodrecipeResponse = KroyaAPIResponse<RecipeModel>
typealias userFoodResponse = KroyaAPIResponse<UserFoodModel>

//MARK: Card Food Sell
typealias foodSellResponse = KroyaAPIResponse<FoodSellModel>
