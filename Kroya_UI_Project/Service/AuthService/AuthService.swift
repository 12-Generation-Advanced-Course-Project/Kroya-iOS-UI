//
//  Untitled.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import Alamofire
import Foundation

class AuthService {
    
    static let shared = AuthService()
    
    // Check Email if exists in Database
    func checkEmailExists(email: String, completion: @escaping (Result<EmailCheckResponse, Error>) -> Void) {
        let url = Constants.KroyaUrlAuth + "check-email-exist"
        let parameters: [String: String] = ["email": email]
        
        print("URL: \(url)")
        print("Parameters: \(parameters)")
        print("Email: \(email)") // Ensure this prints the expected email

        // Make the GET request using Alamofire
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: EmailCheckResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    print("""
                    API Response Success:
                    - Code: \(apiResponse.statusCode)
                    - Message: \(apiResponse.message)
                    - Payload: \(String(describing: apiResponse.payload))
                    """)
                    // Check if the email exists based on the payload or message
                    if apiResponse.statusCode == "200" && apiResponse.payload != nil {
                        print("->Email exists: \(apiResponse.message)")
                        completion(.success(apiResponse))
                    } else {
                        // If email does not exist, return an error
                        let customError = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(customError))
                    }
                    
                case .failure(_):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 404:
                            let customError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Email not registered. Please register your account."])
                            print("->\(customError.localizedDescription)")
                            completion(.failure(customError))
                        default:
                            let unexpectedError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected response status code \(statusCode)"])
                            print("->Email doesn't exist: \(unexpectedError.localizedDescription)")
                            completion(.failure(unexpectedError))
                        }
                    } else {
                        let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No status code in response"])
                        print("->Error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }
    }


    
    // Send OTP Code
    func sendOTP(_ email: String, completion: @escaping (Result<SendOTPResponse, Error>) -> Void) {
        let url = Constants.KroyaUrlAuth + "send-otp"
        let parameters: [String: String] = ["email": email]
        
        // Pretty print request details
        print("""
           Sending OTP request:
           - URL: \(url)
           - Parameters: \(parameters)
           """)
        
        AF.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: SendOTPResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    // Pretty print success response
                    if apiResponse.statusCode == "200" {
                        completion(.success(apiResponse))
                    }
                    print("""
                    API Response Success:
                    - Code: \(apiResponse.statusCode)
                    - Message: \(apiResponse.message)
                    - Payload: \(String(describing: apiResponse.payload))
                    """)
                    
                case .failure(_):
                    print("Status Code = \(String(describing: response.response?.statusCode))")
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 400:
                            print("Error: Bad request (400).")
                            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad request. Please try again."])
                            completion(.failure(error))
                        default:
                            print("Error: Unexpected response status code \(statusCode).")
                            let unexpectedError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected response status code \(statusCode)"])
                            completion(.failure(unexpectedError))
                        }
                    } else {
                        print("Error: No status code in response or network error.")
                        let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No status code in response or network issue."])
                        completion(.failure(error))
                    }
                }
            }
    }

    
    // MARK: VerifyOTP Code Email
    func VerifyOTPCode(_ email: String, _ code: String, completion: @escaping (Result<VerificationCodeRequestResponse, Error>) -> Void) {
        let url = Constants.KroyaUrlAuth + "validate-otp"
        let parameters: [String: String] = ["email": email, "otp": code]
        print("URL: \(url)")
        print("Parameters: \(parameters)")
        
        // Make the request
        AF.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: VerificationCodeRequestResponse.self) { response in
               
                switch response.result {
                case .success(let apiResponse):
                    print("Response: \(apiResponse)")
                    
                    // Convert statusCode to Int if needed
                    if let statusCode = Int(apiResponse.statusCode) {
                        switch statusCode {
                        case 200:
                            print("OTP validated successfully!")
                            completion(.success(apiResponse))
                        case 400:
                            print("OTP is invalid. Please input the correct OTP code!")
                            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "OTP is invalid. Please try again."])
                            completion(.failure(error))
                        default:
                            print("Unknown error occurred. StatusCode: \(statusCode)")
                            let unknownError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred. Please try again."])
                            completion(.failure(unknownError))
                        }
                    } else {
                        print("Failed to parse status code.")
                        let parseError = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse server response."])
                        completion(.failure(parseError))
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }


}

