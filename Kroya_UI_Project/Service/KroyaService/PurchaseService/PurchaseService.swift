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
    
    // Fetch All Purchases method
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
   }
    
    


