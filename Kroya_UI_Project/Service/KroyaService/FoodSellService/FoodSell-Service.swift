
//
import Alamofire
import Foundation

class FoodSellService : ObservableObject{
   // static let shared = FoodSellService()
    
    // Fetch all FoodSell
    func fetchAllFoodSell(completion: @escaping (Result<[FoodSell], Error>) -> Void) {
        
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }

        let endpoint = Constants.foodOnSale + "list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        AF.request(endpoint, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FoodSellListResponse<[FoodSell]>.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let apiResponse):
                    if let foodSells = apiResponse.payload {
                        completion(.success(foodSells))
                    } else {
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No addresses found."])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
