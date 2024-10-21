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
    
    //MARK: Check Email if exists in Database
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
    
    
    
    // MARK: Send OTP Code
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
    
    
    // MARK: Create Password for Register
    func createPassword(email: String,password: String,confirmPassword: String, completion: @escaping (Result<CreatePasswordResponse, Error>) -> Void) {
        let url = Constants.KroyaUrlAuth + "register"
        let parameters: [String: String] = ["email": email, "newPassword": password,"confirmPassword":confirmPassword]
        print("URL: \(url)")
        print("Parameters: \(parameters)")
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate()
            .responseDecodable(of: CreatePasswordResponse.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let ApiResponse):
                    if let statusCode = Int(ApiResponse.statusCode) {
                        switch statusCode {
                        case 200:
                            print("Succes Register account successfully!")
                            completion(.success(ApiResponse))
                        case 010:
                            print("Your Password not match!!!. Please enter the match password")
                            let error = NSError(domain: "", code: 010, userInfo: [NSLocalizedDescriptionKey: "Password not match with Confirm Password. Please enter the match password"])
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
                        completion(.success(ApiResponse))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: Login Account
    func LoginAccount(email:String,password:String, completion: @escaping (Result<LoginAccountResponse, Error>) -> Void) {
        let url = Constants.KroyaUrlAuth + "login"
        let parameters: [String: String] = ["email": email, "password": password]
        print("URL: \(url)")
        print("Parameters: \(parameters)")
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate()
            .responseDecodable(of: LoginAccountResponse.self) { response in
            
                switch response.result {
                case .success(let ApiResponse):
                    if let statusCode = Int(ApiResponse.statusCode) {
                        switch statusCode {
                        case 200:
                            print("Succes Login account successfully!")
                            completion(.success(ApiResponse))
                        case 002:
                            print("Your Password is incorrect . Please enter the correct password")
                            let error = NSError(domain: "", code: 002, userInfo: [NSLocalizedDescriptionKey: "Password not match with Confirm Password. Please enter the match password"])
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
                        completion(.success(ApiResponse))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: Refresh_Token
    func refreshToken(refreshToken: String, completion: @escaping (Result<RefreshTokenResponse, Error>) -> Void) {
        let url = Constants.KroyaUrlAuth + "refresh-token"
        
        // Set the Authorization header using the refresh token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)",
            "Content-Type": "application/json"
        ]
        
        print("URL: \(url)")
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: RefreshTokenResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                        if let tokens = apiResponse.payload {
                            // Print the new access and refresh tokens
                            print("New Access Token: \(tokens.access_token)")
                            print("New Refresh Token: \(tokens.refresh_token)")
                            
                            // Handle success and pass the tokens in completion handler
                            completion(.success(apiResponse))
                        } else {
                            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Payload is empty."])
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to refresh token."])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }



}
