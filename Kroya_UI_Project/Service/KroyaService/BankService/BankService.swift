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
        
        let url = "https://api.webill365.com/kh/api/wbi/client/v1/auth/token"
        print("Client : \(clientID) and SecretID : \(clientSecret)")
        let trimmedClientID = clientID.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedClientSecret = clientSecret.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parameters
        let parameters: [String: Any] = [
            "client_id": trimmedClientID,
            "client_secret": trimmedClientSecret
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
        .responseDecodable(of: WeBill365Response.self) { response in
            // Handle the response
            debugPrint(response)
            switch response.result {
            case .success(let data):
                if let accessToken = data.data?.accessToken {
                    // Save the access token using Auth class
//                    Auth.shared.setWeBillCredentials(clientId: clientID, secretId: clientSecret, webillToken: accessToken, parentAccount: parentAccount)
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
    
    // MARK: Get Token for Access into WeBill365
    func weBill365TokenFromSeller(clientID: String, clientSecret: String, completion: @escaping (Bool) -> Void) {
        let url = "https://api.webill365.com/kh/api/wbi/client/v1/auth/token"
        print("Client : \(clientID) and SecretID : \(clientSecret)")
        let trimmedClientID = clientID.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedClientSecret = clientSecret.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parameters
        let parameters: [String: Any] = [
            "client_id": trimmedClientID,
            "client_secret": trimmedClientSecret
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
        .responseDecodable(of: WeBill365Response.self) { response in
            debugPrint(response) // Debugging the response
            switch response.result {
            case .success(let data):
                if let accessToken = data.data?.accessToken {
                    Auth.shared.setWebillToken(webillToken: accessToken) // Save the token
                    print("Access token retrieved and saved successfully.")
                    completion(true)
                } else {
                    let errorMessage = data.status?.message ?? "Failed to retrieve access token."
                    print("Error: \(errorMessage)")
                    completion(false)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(false)
            }
        }
    }

    // MARK: QR Collection
    func QuickBills(quickBillsRequest: QuickBillsRequest, completion: @escaping (Result<QRCollectionResponse<DataForQRCollection>, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessTokenWeBill() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        let url = "https://api.webill365.com/kh/api/wbi/client/v1/quick-bills"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "account_name": quickBillsRequest.accountName,
            "payment_type": quickBillsRequest.paymentType,
            "currency_code": quickBillsRequest.currencyCode,
            "issue_datetime": quickBillsRequest.issueDatetime,
            "payment_term": quickBillsRequest.paymentTerm,
            "parent_account_no": quickBillsRequest.parentAccountNo,
            "amount" : quickBillsRequest.amount,
            "remark": quickBillsRequest.remark
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
    func QRCheckStatus(QrcheckStatus: CheckStatusCodeRequest, completion: @escaping (Result<CheckingStatus<[DataForQRCollection]>, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessTokenWeBill() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }

        let url = "https://api.webill365.com/kh/api/wbi/client/v1/payments/check-status"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "bill_no": QrcheckStatus.billNo
        ]

        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: CheckingStatus<[DataForQRCollection]>.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let apiResponse):
                if let status = apiResponse.status, status.code == 200 {
                    completion(.success(apiResponse))
                }
            case .failure(let error):
                print("Failed to fetch QR status: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }


    // MARK: - Connect WeBill API Call
    func connectWeBill(
        request: ConnectWebillConnectRequest,
        completion: @escaping (Result<ConnectWebillResponseData, Error>) -> Void
    ) {
        // Get access token
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Access token is missing"]
            )
            completion(.failure(error))
            return
        }
        
        // API Endpoint
        let url = Constants.ConnectWeBillUrl
        
        // HTTP Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        // Parameters
        let parameters: [String: Any] = [
            "clientId": request.clientId,
            "clientSecret": request.clientSecret,
            "accountNo": request.accountNo
        ]
        
        // API Request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: ConnectWebillResponseData.self) { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(
                            domain: "",
                            code: Int(apiResponse.statusCode) ?? 400,
                            userInfo: [NSLocalizedDescriptionKey: apiResponse.message]
                        )
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    // MARK: - Get WeBill Credential User Account
    func getWeBillAccountCredential(SellerId: Int, completion: @escaping (Result<ConnectWebillResponseData, Error>) -> Void) {
        // Get access token
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Access token is missing"]
            )
            completion(.failure(error))
            return
        }
        // API Endpoint
        let url = Constants.GetCredentialUserWeBillAccountUrl + "/\(SellerId)"
        
        // HTTP Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        // API Request
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: ConnectWebillResponseData.self) { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(
                            domain: "",
                            code: Int(apiResponse.statusCode) ?? 400,
                            userInfo: [NSLocalizedDescriptionKey: apiResponse.message]
                        )
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    // MARK: - Disconnect WeBill Account
    func disConnectWeBillAccount(completion: @escaping (Result<DisconnectWeBillAccountResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Access token is missing"]
            )
            completion(.failure(error))
            return
        }
        
        // API Endpoint
        let url = Constants.KroyaUrlUser + "disconnectWebill"
        
        // HTTP Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        // API Request
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseDecodable(of: DisconnectWeBillAccountResponse.self) { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(
                            domain: "",
                            code: Int(apiResponse.statusCode) ?? 400,
                            userInfo: [NSLocalizedDescriptionKey: apiResponse.message]
                        )
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getSellerCredientail(sellerId: Int? ,completion: @escaping (Result<SellerCredentials, Error>) -> Void){
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Access token is missing"]
            )
            completion(.failure(error))
            return
        }
        
        let url = Constants.KroyaUrlUser + "webill-acc-no/\(sellerId!)"
        
        // HTTP Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: SellerCredentials.self) { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(
                            domain: "",
                            code: Int(apiResponse.statusCode) ?? 400,
                            userInfo: [NSLocalizedDescriptionKey: apiResponse.message]
                        )
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
}
