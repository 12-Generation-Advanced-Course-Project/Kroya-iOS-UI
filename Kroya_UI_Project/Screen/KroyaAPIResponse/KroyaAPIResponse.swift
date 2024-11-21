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
typealias UserSettingProfileResponse = KroyaSingleAPIResponse<ProfileModel>
typealias DeviceTokenResponse = KroyaAPIResponse<DeviceTokenModel>
//MARK: Food-Recipe get all
typealias foodrecipeResponse = KroyaAPIResponse<FoodRecipeModel>
typealias SavefoodRecipeResponse = KroyaSingleAPIResponse<FoodRecipeResponse>
//MARK: UserFoodResponse
typealias userFoodResponse = KroyaSingleAPIResponse<UserFoodModel>
//MARK: Food-Sell get all
typealias foodSellResponse = KroyaAPIResponse<FoodSellModel>

//MARK: Foods
typealias popularResponse = KroyaSingleAPIResponse<PopularPayload>
typealias FoodDetailSellResponse = KroyaSingleAPIResponse<FoodSellDetails>
typealias FoodDetailRecipeResponse = KroyaSingleAPIResponse<FoodRecipeDetail>

typealias SaveFoodSellResponse = KroyaSingleAPIResponse<FoodSellResponse>
//MARK: Get all Food by category
typealias getAllFoodCategoryResponse = KroyaSingleAPIResponse<PayloadCategory>
typealias getAllFavoriteResponse = KroyaSingleAPIResponse<FavoritePayload>
// Generic API response for a single object payload
struct KroyaSingleAPIResponse<T: Decodable>: Decodable {
    let message: String
    let payload: T?
    let statusCode: String
    let timestamp: String?
}
//MARK: Feedback Response
typealias FeedbackResponse = KroyaSingleAPIResponse<FeedBackModel>
typealias GetAllUserFeedbackResponse = KroyaSingleAPIResponse<FeedBackModel>

//MARK: Fetch all User Food (View Account)
typealias ViewAccountResponse = KroyaSingleAPIResponse<ViewAccountUserFoodModel>


// MARK: fetch purchase all
typealias purchaseResponse = KroyaAPIResponse<OrderModel>
typealias OrderRequestResponse = KroyaAPIResponse<OrderRequestModel>


//MARK: Add Item to Favorite
typealias AddFavouriteResponse = KroyaSingleAPIResponse<String>
typealias RemoveFavoriteResponse = KroyaSingleAPIResponse<String>
//MARK: Add a Purchase
typealias AddPurchaseResponse = KroyaSingleAPIResponse<PurchaseModel>


//MARK: Guest food popular
typealias GuestFoodPopularResponses = KroyaSingleAPIResponse<PopularPayload>

//MARK: Guest category
typealias GuestCategoryAllFoodById = KroyaSingleAPIResponse<PayloadCategory>
typealias GuestCategoryResponse = KroyaAPIResponse<CategoryModel>
