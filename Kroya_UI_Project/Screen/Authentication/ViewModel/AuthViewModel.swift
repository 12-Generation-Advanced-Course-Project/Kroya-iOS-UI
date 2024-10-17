//
//  AuthViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 12/10/24.
//

import SwiftUI
import Foundation
import Alamofire

class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isEmailExist: Bool = false
    @Published var showError: Bool = false
    @Published var successMessage: String = ""
    @Published var errorMessage: String = ""
    @Published var isOTPSent: Bool = false
    @Published var isOTPVerified: Bool = false
    @Published var isRegistered: Bool = false
    @Published var isLoggedIn: Bool = false
 
    
    private var userStore: UserStore
    init(userStore: UserStore) {
           self.userStore = userStore
       }


    
    // MARK: Check if email exists, and send OTP if it doesn't
    func sendOTPIfEmailNotExists(email: String) {
        self.isLoading = true
        let normalizedEmail = email
        print("Checking if email exists: \(normalizedEmail)")

        AuthService.shared.checkEmailExists(email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        // Email exists
                        self?.isEmailExist = true
                        self?.showError = false
                        self?.successMessage = response.message
                        print("Email exists: \(response.message)")
                        self?.userStore.setUser(email: email)
                    }
                    
                case .failure(let error):
                    // Email does not exist, proceed to send OTP
                    self?.isEmailExist = false
                    print("Email not registered. Sending OTP...")
                    self?.sendOTP(email: email) { success in
                        if success {
                            // Store user information after sending OTP
                            self?.userStore.setUser(email: email)
                            print("OTP sent successfully.")
                        } else {
                            self?.showError = true
                            self?.errorMessage = "Failed to send OTP. Please try again."
                            print("Failed to send OTP.")
                        }
                    }
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                    print("\(error.localizedDescription)")
                }
            }
        }
    }


    // MARK: Function to send OTP
    func sendOTP(email: String, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        print("Sending OTP to: \(email)")
        
        AuthService.shared.sendOTP(email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    self?.successMessage = "OTP sent successfully. Please check your email."
                    self?.isOTPSent = true
                    self?.showError = false
                    
                    completion(true)
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                    print("Error sending OTP: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }



    // MARK: VerifyOTPcode
    func verifyOTPcode(_ email: String, _ code: String) {
        self.isLoading = true
        print("Verifying OTP code: \(code)")

        AuthService.shared.VerifyOTPCode(email, code) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        print("OTP verified successfully.")
                        self?.successMessage = "OTP verified successfully."
                        self?.showError = false
                        self?.isOTPVerified = true
                        self?.errorMessage = ""  // Clear previous errors
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                        print("OTP verification failed: \(response.message)")
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                    print("Error verifying OTP: \(error)")
                }
            }
        }
    }

    
    // MARK: Register Create Password
    func register(_ email: String, _ newPassword: String, _ confirmPassword: String) {
//        guard newPassword == confirmPassword else {
//            self.showError = true
//            self.successMessage = "Passwords do not match."
//            return
//        }
//        guard !email.isEmpty, !newPassword.isEmpty, isValidEmail(email) else {
//            self.showError = true
//            self.successMessage = "Please enter a valid email and password."
//            return
//        }
        self.isLoading = true
        print("Passwords match. Proceeding to create the password...")
        AuthService.shared.createPassword(email: email, password: newPassword, confirmPassword: confirmPassword) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
               
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let tokenPayload = response.payload {
                            let accessToken = tokenPayload.access_token
                            // Store only the accessToken in UserStore
                            self?.userStore.setUser(
                                email: email,
                                accesstoken: accessToken
                            )
                            self?.isRegistered = true
                            // Optionally, save the access token in Keychain
                            KeychainHelper.shared.save(accessToken, service: "com.Kroya-UI-Project.accessToken", account: email)
                        }
                        self?.successMessage = "Register account successful"
                        self?.showError = false
                    } else {
                        print("Error: \(response.message)")
                        self?.showError = true
                        self?.successMessage = response.message
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }


    // MARK: Login Account Email
       func loginAccountEmail(email: String, password: String) {
           self.isLoading = true
           AuthService.shared.LoginAccount(email: email, password: password) { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let response):
                       if response.statusCode == "200", let token = response.payload {
                           // Update user store and Keychain
                           let accessToken = token.access_token
                           let refreshToken = token.refresh_token
                           self?.userStore.setUser(email: email, accesstoken: accessToken, refreshtoken: refreshToken)
                           
                           // Save tokens in Keychain (optional)
//                           KeychainHelper.shared.save(accessToken, service: "com.Kroya-UI-Project.accessToken", account: email)
//                           KeychainHelper.shared.save(refreshToken, service: "com.Kroya-UI-Project.refreshToken", account: email)
                           
                           self?.isLoggedIn = true
                           self?.successMessage = "Successfully logged in"
                           self?.showError = false
                       } else {
                           self?.successMessage = "Invalid email or password"
                           self?.showError = true
                       }
                   case .failure(_):
                       self?.successMessage = "Please enter a valid email and password"
                       self?.showError = true
                   }
                   print("isLoggedIn: \(self?.isLoggedIn ?? false)")  // Debug print
               }
           }
       }

    //MARK: Validate Email
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
//
//   
//
//    func makeAuthorizedRequest(email: String) {
//        guard let accessToken = KeychainHelper.shared.read(service: "com.Kroya-UI-Project.accessToken", account: email),
//              let refreshToken = KeychainHelper.shared.read(service: "com.Kroya-UI-Project.refreshToken", account: email) else {
//            print("No tokens found, user needs to log in.")
//            return
//        }
//
//        // Simulate checking if the access token is expired
//        if isAccessTokenExpired(accessToken) {
//            // Refresh the access token using the refresh token
//            refreshAccessToken(email: email, refreshToken: refreshToken) { [weak self] success in
//                if success {
//                    // Now make the actual request using the new access token
//                    self?.performAPIRequest(email: email)
//                } else {
//                    print("Failed to refresh token, user may need to log in again.")
//                }
//            }
//        } else {
//            // Access token is valid, proceed with the request
//            performAPIRequest(email: email)
//        }
//    }
//
//    func performAPIRequest(email: String) {
//        guard let accessToken = KeychainHelper.shared.read(service: "com.Kroya-UI-Project.accessToken", account: email) else {
//            print("No access token found.")
//            return
//        }
//
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(accessToken)",
//            "Content-Type": "application/json"
//        ]
//        
//        let url = Constants.KroyaUrlAuth + "/some-protected-endpoint"
//        
//        AF.request(url, method: .get, headers: headers).response { response in
//            // Handle the response
//        }
//    }
//
//    func isAccessTokenExpired(_ token: String) -> Bool {
//        // Logic to check if the token is expired (you can decode the token to check the expiry time)
//        return false // Replace with actual check
//    }
//
//    // Function to refresh access token
//    func refreshAccessToken(email: String, refreshToken: String, completion: @escaping (Bool) -> Void) {
//        AuthService.shared.refreshToken(refreshToken: refreshToken) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    if response.statusCode == "200", let tokenPayload = response.payload {
//                        let newAccessToken = tokenPayload.access_token
//                        let newRefreshToken = tokenPayload.refresh_token
//                        
//                        // Update the tokens in UserStore and Keychain
//                        self?.userStore.setUser(
//                            email: email,
//                            accesstoken: newAccessToken,
//                            refreshtoken: newRefreshToken
//                        )
//
//                        // Replace both tokens
//                        KeychainHelper.shared.save(newAccessToken, service: "com.Kroya-UI-Project.accessToken", account: email)
//                        KeychainHelper.shared.save(newRefreshToken, service: "com.Kroya-UI-Project.refreshToken", account: email)
//
//                        print("Access token refreshed successfully.")
//                        completion(true)
//                    } else {
//                        print("Failed to refresh access token: \(response.message)")
//                        completion(false)
//                    }
//                case .failure(let error):
//                    print("Error refreshing access token: \(error.localizedDescription)")
//                    completion(false)
//                }
//            }
//        }
//    }
//




}
