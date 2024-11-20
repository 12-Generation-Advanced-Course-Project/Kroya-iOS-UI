//
//  PurchaseService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Alamofire

class PurchaseService: ObservableObject {
    
    static let shared = PurchaseService()
    
    // MARK: Fetch All Purchases method
    func getAllPurchases(completion: @escaping (Result<purchaseResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }
        
        let url = Constants.PurchaseeUrl + "all"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: purchaseResponse.self) { respons in
            
            if let statusCode = respons.response?.statusCode {
                // Check for 404 status code and handle it gracefully
                if statusCode == 404 {
                    print("Not found Purchase")
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found Purchase."])))
                    return
                }
            }
            
            // Pretty print the JSON response for debugging
            if let data = respons.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        print("Pretty JSON Response:\n\(prettyString)")
                    }
                } catch {
                    print("Failed to convert response data to pretty JSON: \(error)")
                }
            }
            
            
            // Handle the response result
            switch respons.result {
            case .success(let payloads):
                completion(.success(payloads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    //MARK: Get search Purchase By Name
    func getSearchPurchaseByName(searchText: String, completion: @escaping (Result<purchaseResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Construct the URL with the search query
        let url = "\(Constants.SearchPurchaseeByNameUrl)search?name=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: purchaseResponse.self) { response in
            // Print response data for debugging
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
            }
            
            // Handle the result
            switch response.result {
            case .success(let apiResponse):
                if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    // MARK: Fetch All Purchases Order method
    func getPurchaseOrder(completion: @escaping (Result<purchaseResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }
        
        let url = Constants.PurchaseOrderUrl + "buyer"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: purchaseResponse.self) { respons in
            
            if let statusCode = respons.response?.statusCode {
                // Check for 404 status code and handle it gracefully
                if statusCode == 404 {
                    print("Not found Purchase Buyer")
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found Purchase Buyer."])))
                    return
                }
            }
            
            // Pretty print the JSON response for debugging
            if let data = respons.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        print("Pretty JSON Response:\n\(prettyString)")
                    }
                } catch {
                    print("Failed to convert response data to pretty JSON: \(error)")
                }
            }
            
            // Handle the response result
            switch respons.result {
            case .success(let payloads):
                completion(.success(payloads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    // MARK: Fetch All Purchases Order method
    func getPurchaseSale(completion: @escaping (Result<purchaseResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }
        
        let url = Constants.PurchaseSalesUrl + "items"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: purchaseResponse.self) { respons in
            
            if let statusCode = respons.response?.statusCode {
                // Check for 404 status code and handle it gracefully
                if statusCode == 404 {
                    print("Not found Purchase Saller")
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found Purchase Saller."])))
                    return
                }
            }
            
            // Pretty print the JSON response for debugging
            if let data = respons.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        print("Pretty JSON Response:\n\(prettyString)")
                    }
                } catch {
                    print("Failed to convert response data to pretty JSON: \(error)")
                }
            }
            
            // Handle the response result
            switch respons.result {
            case .success(let payloads):
                completion(.success(payloads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: Add Purchaes
    func AddPurchase(
        purchase: PurchaseRequest,
        paymentType: String,
        completion: @escaping (Result<PurchaseResponse, Error>) -> Void
    ) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            // Handle missing access token
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Access token not found."]
            )
            completion(.failure(error))
            return
        }

        // API URL
        let url = Constants.PurchaseAdd + "?paymentType=\(paymentType)"

        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        // Construct the parameters
        let parameters: [String: Any] = [
            "purchaseRequest": [
                "foodSellId": purchase.foodSellId,
                "remark": purchase.remark ?? "",
                "location": purchase.location,
                "quantity": purchase.quantity,
                "totalPrice": purchase.totalPrice // Ensure this is a Double
            ],
            "paymentType": paymentType
        ]

        // Alamofire Request
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default, // Encode as JSON
            headers: headers
        )
        .validate(statusCode: 200..<500) // Allow only successful responses
        .responseDecodable(of: PurchaseResponse.self) { response in
            // Log the response
            if let data = response.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        print("Response Successfully for AddPurchase:\n\(prettyString)")
                    }
                } catch {
                    print("Failed to convert response data to pretty JSON: \(error)")
                }
            }

            debugPrint(response)

            // Handle the response
            switch response.result {
            case .success(let purchaseResponse):
                completion(.success(purchaseResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
}




