//
//  FeebackService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import Foundation
import Alamofire

class FeedbackService {
    static let shared = FeedbackService()

    private let baseURL = "https://kroya-api-production.up.railway.app/api/v1/feedback"

    // MARK: Feedback on Food
    
    func feedbackOnFood(
        itemType: String,
        foodId: Int,
        ratingValue: Int?,
        commentText: String?,
        completion: @escaping (Result<FeedBackModel, Error>) -> Void
    ) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Query parameters
        let url = "\(baseURL)?itemType=\(itemType)"
        
        // Body parameters
        var parameters: [String: Any] = [
            "foodId": foodId
        ]
        if let ratingValue = ratingValue {
            parameters["ratingValue"] = ratingValue
        }
        if let commentText = commentText {
            parameters["commentText"] = commentText
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        // Send the request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: FeedbackResponse.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let feedbackResponse):
                    if let feedback = feedbackResponse.payload {
                        completion(.success(feedback))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No payload in response"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }


    
    // MARK: - Get Feedback
    func getFeedback(itemType: String, foodId: Int, completion: @escaping (Result<FeedBackModel, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Construct URL with query parameters
        let url = "\(baseURL)/\(foodId)?itemType=\(itemType)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: FeedbackResponse.self) { response in
                debugPrint(response) // Debugging the response
                switch response.result {
                case .success(let feedbackResponse):
                    if let feedback = feedbackResponse.payload {
                        completion(.success(feedback)) // Return the payload
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No payload in response"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: Get All Feedback for a Food
    func getAllFeedback(
        itemType: String,
        foodId: Int,
        completion: @escaping (Result<[FeedBackModel], Error>) -> Void
    ) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }

        // Construct URL with query parameters
        let url = "\(baseURL)/guest-user/\(foodId)?itemType=\(itemType)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: KroyaSingleAPIResponse<[FeedBackModel]>.self) { response in
                
                if let data = response.data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        if let prettyString = String(data: prettyData, encoding: .utf8) {
                            print("Pretty JSON Response:\n\(prettyString)")
                        }
                    } catch {
                        print("Failed to convert response data to pretty JSON: \(error)")
                    }
                } else {
                    print("No response data available")
                }
                switch response.result {
                case .success(let feedbackResponse):
                    if let feedback = feedbackResponse.payload {
                        completion(.success(feedback)) // Return the payload
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No payload in response"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }


}
