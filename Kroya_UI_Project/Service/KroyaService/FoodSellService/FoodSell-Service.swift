//
//  FoodSell-Service.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//
import Alamofire
import Foundation

class FoodSellService {
    static let shared = FoodSellService()
    
    // Fetch all Foo Sell
    func fetchAllAddresses(completion: @escaping (Result<[Address], Error>) -> Void) {
        
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }

        let endpoint = Constants.KroyaAddress + "list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        AF.request(endpoint, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: AddressResponse<[Address]>.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let apiResponse):
                    if let addresses = apiResponse.payload {
                        completion(.success(addresses))
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
