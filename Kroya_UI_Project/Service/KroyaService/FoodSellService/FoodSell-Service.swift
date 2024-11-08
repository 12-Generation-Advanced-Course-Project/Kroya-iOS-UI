


import Alamofire
import SwiftUI

class FoodSellService {
    static let shared = FoodSellService()
    
    // MARK: Get User Profile
    func getFoodSell(completion: @escaping (Result<FoodSellListResponse, Error>) -> Void) {
        let url = Constants.foodSell + "list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")"
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: FoodSellListResponse.self) { response in
                debugPrint(response)
                switch response.result{
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                        print("Food sell retrieved successfully.")
                        print("Food Sell:\(String(describing: apiResponse.payload))")
                        completion(.success(apiResponse))
                    } else {
                        print("Failed to retrieve Food Sell.")
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: Update Profile Request
//       func sendUpdateProfileRequest(fullName: String, phoneNumber: String, address: String, profileImageName: String, completion: @escaping (Result<UserSettingProfileResponse, Error>) -> Void) {
//           guard let accessToken = Auth.shared.getAccessToken() else {
//               let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
//               completion(.failure(error))
//               return
//           }
//
//           let url = Constants.KroyaUrlUser + "edit-profile"
//           let headers: HTTPHeaders = [
//               "Authorization": "Bearer \(accessToken)",
//               "Content-Type": "application/json"
//           ]
//
//           let parameters: [String: Any] = [
//               "profileImage": profileImageName,
//               "fullName": fullName,
//               "phoneNumber": phoneNumber,
//               "location": address
//           ]
//
//           // Use PUT instead of POST
//           AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//               .responseDecodable(of: UserSettingProfileResponse.self) { response in
//                   debugPrint(response)
//                   switch response.result {
//                   case .success(let result):
//                       if result.statusCode == "200" {
//                           if let updatedProfile = result.payload {
//                               print(updatedProfile)
//                           } else {
//                               let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Profile update failed: Missing payload."])
//                               completion(.failure(error))
//                           }
//                       } else {
//                           let error = NSError(domain: "", code: Int(result.statusCode) ?? 500, userInfo: [NSLocalizedDescriptionKey: result.message])
//                           completion(.failure(error))
//                       }
//                   case .failure(let error):
//                       print("Error: \(error)")
//                       completion(.failure(error))
//                   }
//               }
//       }
}


//class FoodSellService : ObservableObject{
//   // static let shared = FoodSellService()
//    
//    // Fetch all FoodSell
//    func fetchAllFoodSell(completion: @escaping (Result<[FoodSell], Error>) -> Void) {
//        
//        guard let accessToken = Auth.shared.getAccessToken() else {
//            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
//            completion(.failure(error))
//            return
//        }
//
//        let endpoint = Constants.foodOnSale + "list"
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(accessToken)"
//        ]
//
//        AF.request(endpoint, method: .get, headers: headers)
//            .validate()
//            .responseDecodable(of: FoodSellListResponse<[FoodSell]>.self) { response in
//                debugPrint(response)
//                switch response.result {
//                case .success(let apiResponse):
//                    if let foodSells = apiResponse.payload {
//                        completion(.success(foodSells))
//                    } else {
//                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No addresses found."])
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//}
