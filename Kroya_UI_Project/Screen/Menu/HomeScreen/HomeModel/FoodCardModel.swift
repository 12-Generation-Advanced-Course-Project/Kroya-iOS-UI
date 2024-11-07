

import Foundation


import Foundation

struct FoodSellListResponse: Codable {
    let message: String
    let payload: [FoodSell]
    let status, timestamp: String
}

// MARK: - Payload
struct FoodSell: Codable{
    let foodSellId: Int
    let photo : [Photo]
    let name, dateCooking: String  // Corrected from "dsateCoooking" to "dateCooking"
    let price: Double
    let currencyType: String
    let averageRating: Double
    let totalRaters: Int
    let isFavorite: Bool
    let itemType: String
    let isOrderable: Bool
    let sellerInformation: String
    
    enum CodingKeys: String, CodingKey {
        case foodSellId, photo, name, dateCooking, price, currencyType, averageRating, totalRaters, isFavorite, itemType, isOrderable, sellerInformation
    }
}
//
//
//    // MARK: - Photo
//    struct Photo: Codable {
//        let photoId: Int
//        let photo: String
//
//        enum CodingKeys: String, CodingKey {
//            case photoId, photo
//        }
//    }
