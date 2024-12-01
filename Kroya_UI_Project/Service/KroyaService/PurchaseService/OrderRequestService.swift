//
//  OrderRequestService.swift
//  Kroya_UI_Project
//  Created by KAK-LY on 19/11/24.
//

import SwiftUI
import Alamofire

class OrderRequestService: ObservableObject {
    
    static let shared = OrderRequestService()
    
    //MARK: Get Orders for Seller by Id
    func getOrderForSellerById(sellerId: Int, completion: @escaping (Result<OrderRequestResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Construct the URL with the seller ID
        let url = "\(Constants.OrderRequestUrl)\(sellerId)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: OrderRequestResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

