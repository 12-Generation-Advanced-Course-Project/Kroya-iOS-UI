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
            
            debugPrint(respons)
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
    func getPurchaseOrder(completion: @escaping (Result<OrderModelResponseForBuyer, Error>) -> Void) {
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
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: OrderModelResponseForBuyer.self) { response in
            
            if let statusCode = response.response?.statusCode {
                if statusCode == 404 {
                    print("Not found Purchase Buyer")
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found Purchase Buyer."])))
                    return
                }
            }
            
            // Pretty print the JSON response for debugging
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
           
            switch response.result {
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
            debugPrint(respons)
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
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Access token not found."]
            )
            completion(.failure(error))
            return
        }
        
        // API URL with paymentType as a query parameter
        let url = Constants.Purchase + "?paymentType=\(paymentType)"
        
        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        // Parameters without nesting under "purchaseRequest"
        let parameters: [String: Any] = [
            "foodSellId": purchase.foodSellId,
            "remark": purchase.remark ?? "",
            "location": purchase.location,
            "quantity": purchase.quantity,
            "totalPrice": purchase.totalPrice
        ]
        
        // Alamofire Request
      
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let apiResponse = try JSONDecoder().decode(PurchaseResponse.self, from: data)
                    if apiResponse.statusCode == "200" {
                        completion(.success(apiResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    //GET ALL Receipt By PurchaseId
    func getReceiptByPurchaseId(purchaseId: Int,completion: @escaping (Result<PurchaseModel?, Error>) -> Void
    ) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Access token not found."]
            )
            completion(.failure(error))
            return
        }
        let url = Constants.Purchase + "/receipt/\(purchaseId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: ReceiptResponse.self) { respons in
            
            if let statusCode = respons.response?.statusCode {
                // Check for 404 status code and handle it gracefully
                if statusCode == 404 {
                    print("Not found Purchase")
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
                    print("Failed to parse JSON response: \(error)")
                }
            }
            
            debugPrint(respons)
            // Handle the response result
            switch respons.result {
            case .success(let ReceiptResponse):
                if let payload = ReceiptResponse.payload {
                    completion(.success(payload))
                } else {
                    print("Message from server: \(ReceiptResponse.message)")
                    completion(.success(nil)) // Indicate no data, but not an error
                }
            case .failure(let error):
                if let afError = error as? AFError, let responseCode = afError.responseCode, responseCode == 404 {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "The purchase ID does not exist. Please check your order."])))
                } else {
                    completion(.failure(error))
                }
                
            }
            
            
        }
        
    }
    
    //MARK: Update Purchase By Id and Status
    func UpdatePurchaseByPurchaseId(
        purchaseId: Int,
        newStatus: String,
        completion: @escaping (Result<PurchaseUpdateResponse, Error>) -> Void
    ) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Access token not found."]
            )
            completion(.failure(error))
            return
        }

        // Adjust URL to match correct endpoint
        let url = Constants.Purchase + "/orders/\(purchaseId)/status?newStatus=\(newStatus)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        // Debugging: Log the URL and headers
        print("URL: \(url)")
        print("Headers: \(headers)")

        AF.request(url, method: .put, headers: headers).validate().responseDecodable(of: PurchaseUpdateResponse.self) { response in
            
            // Debugging: Print the response status code and raw data
            if let statusCode = response.response?.statusCode {
                print("Status Code: \(statusCode)")
                if statusCode == 404 {
                    print("Not found Purchase")
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found Purchase Seller."])))
                    return
                }
            }

            if let data = response.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        print("Pretty JSON Response:\n\(prettyString)")
                    }
                } catch {
                    print("Failed to parse JSON response: \(error)")
                }
            }

            // Handle response result
            switch response.result {
            case .success(let purchaseUpdateResponse):
                completion(.success(purchaseUpdateResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
}



