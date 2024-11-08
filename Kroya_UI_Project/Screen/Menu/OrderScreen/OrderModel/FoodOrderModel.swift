//
//
import Foundation
//
struct FoodSellListResponse: Codable {
    let message: String
    let payload: FoodSellModel?
    let statusCode: String
    let timestamp: String?
}

// MARK: - Payload
struct FoodSellModel: Codable {
    let foodSellId: Int?
    let photo : [Photo]?
    let name, dateCooking: String
    let price: Double
    let currencyType: String?
    let averageRating: Double?
    let totalRaters: Int?
    let isFavorite: Bool?
    let itemType: String?
    let isOrderable: Bool?
    let sellerInformation: User?
    
//    enum CodingKeys: String, CodingKey {
//        case foodSellId, photo, name, dateCooking, price, currencyType, averageRating, totalRaters, isFavorite, itemType, isOrderable, sellerInformation
//    }
}

//   let id = UUID()
//    var imageName           : String
//    var dishName            : String
//    var cookingDate         : String
//    var price               : Double
//    var rating              : Double
//    var reviewCount         : Int
//    var deliveryInfo        : String
//    var deliveryIcon        : String
//
//}
