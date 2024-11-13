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
struct KroyaAPIResponsee<T: Decodable>: Decodable {
    let message: String
    let payload: T
    let statusCode: String
    let timestamp: String?
}
//MARK: User Setting Profile
typealias UserSettingProfileResponse = KroyaAPIResponse<ProfileModel>
//MARK: Food-Recipe get all
typealias foodrecipeResponse = KroyaAPIResponse<FoodRecipeModel>
typealias SavefoodRecipeResponse = KroyaAPIResponse<FoodRecipeResponse>
//MARK: UserFoodResponse
typealias userFoodResponse = KroyaAPIResponse<UserFoodModel>
//MARK: Food-Sell get all
typealias foodSellResponse = KroyaAPIResponse<FoodSellModel>
typealias SaveFoodSellResponse = KroyaAPIResponse<FoodSellResponse>
//MARK: Popular
typealias popularResponse = KroyaAPIResponsee<PopularPayload>


