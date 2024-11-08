
//
//import Foundation
//
//struct FoodSellListResponse<T:Decodable>: Decodable {
//    let message: String
//    let payload: [FoodSell]?
//    let status, timestamp: String
//}
//
//// MARK: - Payload
//struct FoodSell: Codable{
//    let foodSellId: Int
//    let photo : [Photo]
//    let name, dateCooking: String
//    let price: Double
//    let currencyType: String
//    let averageRating: Double
//    let totalRaters: Int
//    let isFavorite: Bool
//    let itemType: String
//    let isOrderable: Bool
//    let sellerInformation: String
//    
//}
////
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
