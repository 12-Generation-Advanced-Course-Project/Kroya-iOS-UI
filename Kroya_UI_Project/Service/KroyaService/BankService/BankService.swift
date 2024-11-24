//
//  BankService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

// BankService.swift

import SwiftUI
import Alamofire
import Foundation
class BankService {
    
    static let shared = BankService()
    
    // MARK: Get Token for Access into WeBill365
    func weBill365Token(clientID: String, clientSecret: String,parentAccount:String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "https://apidev.webill365.com/kh/api/wbi/client/v1/auth/token"
        
        // Parameters
        let parameters: [String: Any] = [
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        
        // Headers
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "accept": "*/*"
        ]
        
        // Alamofire Request
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: WeBill365Response.self) { response in
            // Handle the response
            debugPrint(response)
            switch response.result {
            case .success(let data):
                if let accessToken = data.data?.accessToken {
                    // Save the access token using Auth class
                    Auth.shared.setWeBillCredentials(clientId: clientID, secretId: clientSecret, webillToken: accessToken, parentAccount: parentAccount)
                    print("Access token retrieved and saved successfully.")
                    completion(.success(()))
                } else {
                    let errorMessage = data.status?.message ?? "Failed to retrieve access token."
                    let error = NSError(domain: "", code: data.status?.code ?? -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: QR Collection
    func QRCollection(QRCollectionRequest: QRCollectionRequest, completion: @escaping (Result<QRCollectionResponse<DataForQRCollection>, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessTokenWeBill() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }

        let url = "https://apidev.webill365.com/kh/api/wbi/client/v1/qr-collections"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "payer_name": QRCollectionRequest.payername,
            "parent_account_no": QRCollectionRequest.parentAccountNo,
            "payment_type": QRCollectionRequest.paymentType,
            "currency_code": QRCollectionRequest.currencyCode,
            "amount": QRCollectionRequest.amount,
            "remark": QRCollectionRequest.remark
        ]

        // Make the API request
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: QRCollectionResponse<DataForQRCollection>.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let apiResponse):
                // Since `status` is not optional, directly check `status.code`
                if apiResponse.status?.code == 200 {
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(
                        domain: "",
                        code: apiResponse.status?.code ?? 404,
                        userInfo: [NSLocalizedDescriptionKey: apiResponse.status?.message ?? "Error occurred"]
                    )
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: Check Status for QR Scan
    func QRCheckStatus(QrcheckStatus: CheckStatusCodeRequest, completion: @escaping (Result<QRCollectionResponse<DataForQRCollection>, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessTokenWeBill() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = "https://apidev.webill365.com/kh/api/wbi/client/v1/payments/check-status"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        // Encode the request as parameters
        let parameters: [String: Any] = [
            "bill_no": QrcheckStatus.billNo
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default, 
            headers: headers
        ).responseDecodable(of: QRCollectionResponse<DataForQRCollection>.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let apiResponse):
                if let status = apiResponse.status, status.code == 200 {
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(
                        domain: "",
                        code: apiResponse.status?.code ?? 404,
                        userInfo: [NSLocalizedDescriptionKey: apiResponse.status?.message ?? "Error occurred"]
                    )
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


}
