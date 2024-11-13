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
typealias DeviceTokenResponse = KroyaAPIResponse<DeviceTokenModel>
//MARK: Food-Recipe get all
typealias foodrecipeResponse = KroyaAPIResponse<FoodRecipeModel>
typealias SavefoodRecipeResponse = KroyaSingleAPIResponse<FoodRecipeResponse>
//MARK: UserFoodResponse
typealias userFoodResponse = KroyaAPIResponse<UserFoodModel>
//MARK: Food-Sell get all
typealias foodSellResponse = KroyaAPIResponse<FoodSellModel>
typealias SaveFoodSellResponse = KroyaSingleAPIResponse<FoodSellResponse>
// Generic API response for a single object payload
struct KroyaSingleAPIResponse<T: Decodable>: Decodable {
    let message: String
    let payload: T?
    let statusCode: String
    let timestamp: String?
}
