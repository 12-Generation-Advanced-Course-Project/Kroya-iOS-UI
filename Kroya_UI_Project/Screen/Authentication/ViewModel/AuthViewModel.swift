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
    @Published var countdownTimer: Timer?
    @Published var islogout: Bool = false
    @Published var isUserSave: Bool = false
    @Published var isResetpassword : Bool = false
    @Published var isOTPVerifiedForReset : Bool = false
    @Published var isOTPSendForreset : Bool = false
    
    
    
//    @ObservedObject var userStore: UserStore
//    init(userStore: UserStore) {
//        self.userStore = userStore
//        self.isLoggedIn = Auth.shared.loggedIn
//    }
    
    var userStore: UserStore // Changed to a regular property

    init(userStore: UserStore) {
        self.userStore = userStore
        self.isLoggedIn = Auth.shared.loggedIn
    }

    
    // MARK: Check if email exists, and send OTP if it doesn't
    func sendOTPIfEmailNotExists(email: String) {
        self.isEmailExist = false // Reset state
        self.isOTPSent = false // Reset state
        self.isLoading = true
        let normalizedEmail = email
        print("Checking if email exists: \(normalizedEmail)")
        
        AuthService.shared.checkEmailExists(email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        // Email exists, navigate to FillPasswordScreen
                        self?.isEmailExist = true
                        self?.isOTPSent = false // Ensure OTP flag is false
                        self?.showError = false
                        self?.successMessage = response.message
                        print("Email exists: \(response.message)")
                        // Update user data
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
        
        AuthService.shared.sendOTPForSet(email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    self?.successMessage = "OTP sent successfully. Please check your email."
                    self?.isOTPSent = true
                    self?.showError = false
                    self?.isRegistered = false
                    self?.isOTPVerified = false
                    
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
    
    func sendOTPForReset(email: String, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        print("Sending OTP to: \(email)")
        AuthService.shared.sendOTPForSet(email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    self?.successMessage = "OTP sent successfully. Please check your email."
                    self?.isOTPSendForreset = true
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
    func verifyOTPcode(_ email: String, _ code: String,completion: @escaping() -> Void) {
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
                        self?.errorMessage = ""
                      
                        
                        self?.userStore.setUser(email: email)
                        self?.isRegistered = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                        self?.isOTPVerified = false
                     
                        
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
    
    //MARK: For Reset Password
    func verifyOTPcodeForResetPassword(_ email: String, _ code: String) {
        self.isLoading = true
        print("Verifying OTP code: \(code)")
        AuthService.shared.VerifyOTPCodeForReset(email, code) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        print("OTP verified successfully.")
                        self?.successMessage = "OTP verified successfully."
                        self?.showError = false
                        self?.isOTPVerifiedForReset = true
                  
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                        self?.isOTPVerifiedForReset = false
                        
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
    func register(_ email: String, _ newPassword: String, completion: @escaping () -> Void) {
        self.isLoading = true
        print("Passwords match. Proceeding to create the password...")
        
        AuthService.shared.createPassword(email: email, password: newPassword) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let register = response.payload {
                        let accessToken = register.access_token
                        let refreshToken = register.refresh_token
                        Auth.shared.setCredentials(accessToken: accessToken, refreshToken: refreshToken, email: email)
                        self?.userStore.setUser(email: email, accesstoken: accessToken, password: newPassword)
                        
                        self?.successMessage = "Register account successful"
                        self?.showError = false
                        Auth.shared.isRegistering = true
                        
                        // Add the FCM device token if it exists
                        guard let DeviceToken = Auth.shared.getDeviceTokenForNotifi() else {
                            let error = NSError(
                                domain: "",
                                code: 401,
                                userInfo: [NSLocalizedDescriptionKey: "Access token is missing"]
                            )
                            return
                        }
                        // Example usage
                        DeviceTokenService.shared.addDeviceToken(deviceToken: DeviceToken) { result in
                            switch result {
                            case .success:
                                print("Device token added successfully.")
                            case .failure(let error):
                                print("Failed to add device token: \(error.localizedDescription)")
                            }
                        }

                        
                        completion() // Trigger navigation check
                    } else {
                        print("Error: \(response.message)")
//                        self?.isOTPVerified = false
                        self?.showError = true
                        self?.successMessage = response.message
                        completion()
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    completion()
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
                    if response.statusCode == "200", let token = response.payload, let Email = response.payload {

                        // Save tokens
                        let accessToken = token.access_token
                        let refreshToken = token.refresh_token
                        self?.userStore.setUser(email: email, accesstoken: accessToken, refreshtoken: refreshToken)
                        Auth.shared.setCredentials(accessToken: accessToken, refreshToken: refreshToken, email: email)
                        
                        self?.successMessage = "Successfully logged in"
                        self?.showError = false
                        self?.isLoggedIn = true // Update isLoggedIn in AuthViewModel
                        
                        // Check if FCM token is available and send it to the backend
                        guard let DeviceToken = Auth.shared.getDeviceTokenForNotifi() else {
                            let error = NSError(
                                domain: "",
                                code: 401,
                                userInfo: [NSLocalizedDescriptionKey: "Access token is missing"]
                            )
                            return
                        }
                        DeviceTokenService.shared.addDeviceToken(deviceToken: DeviceToken) { result in
                            switch result {
                            case .success:
                                print("Device token added successfully.")
                            case .failure(let error):
                                print("Failed to add device token: \(error.localizedDescription)")
                            }
                        }
                    } else if response.statusCode == "002" {
                        self?.showError = true
                        self?.errorMessage = "Password is incorrect. Please try again"
                    }
                    
                case .failure:
                    self?.successMessage = "Please enter a valid email and password"
                    self?.showError = true
                }
            }
        }
    }

//    func saveUserInfo(email: String, userName: String, phoneNumber: String, address: String, accessToken: String, refreshToken: String, completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
//        print("Starting API request to save user info.")
//        AuthService.shared.saveUserInfo(userName: userName, phoneNumber: phoneNumber, address: address) { result in
//            switch result {
//            case .success(let userInfoResponse):
//                // Success case
//                completion(.success(userInfoResponse))
//            case .failure(let error):
//                // Failure case
//                print("Failed to save user info: \(error.localizedDescription)")
//                completion(.failure(error))
//            }
//        }
//    }

    
//    //MARK: Save UserInfo
    func saveUserInfo(email: String, userName: String, phoneNumber: String, address: String, accessToken: String, refreshToken: String) {
        self.isLoading = true
        print("Email : \(email), UserName : \(userName), PhoneNumber : \(phoneNumber), Address : \(address)")
        AuthService.shared.saveUserInfo(userName: userName, phoneNumber: phoneNumber, address: address) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    // Success scenario
                    self?.successMessage = "User information saved successfully."
                    self?.showError = false
                    self?.userStore.setUser(email: email, userName: userName, phoneNumber: phoneNumber, address: address)

                    self?.isUserSave = true
                case .failure(let error):
                    // Failure scenario
                    self?.successMessage = "Email not found. Please register before updating info."
                    self?.showError = true
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    
    
    //MARK: Validate Email
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    
//    // MARK: Logout Email Account
//    func logoutApp() {
//        isLoading = true
//        Auth.shared.logout()
//        print("Tokens and access token deleted from Keychain.")
//        if let email = userStore.user?.email {
//            print("This email is logged out: \(email)")
//        } else {
//            print("No email found")
//        }
//        // Clear the user-related data from UserStore
//        userStore.clearUser()
//        // Reset app state after logout
//        isOTPVerified = false
//        isRegistered = false
//        // Simulate a delay to show the progress indicator (optional)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.isLoading = false
//        }
//        islogout = true
//    }
    
    func logoutApp() {
        isLoading = true
        Auth.shared.logout()
        // Update state
        self.isLoggedIn = false // Update isLoggedIn in AuthViewModel
        print("Tokens and access token deleted from Keychain.")
        if let email = userStore.user?.email {
            print("This email is logged out: \(email)")
        } else {
            print("No email found")
        }
        // Clear the user-related data from UserStore
        userStore.clearUser()
        // Reset other states as necessary
        isOTPVerified = false
        isRegistered = false
        showError = false
        successMessage = ""
        errorMessage = ""
        // Stop loading indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }


    
    func resetState() {
        // Only reset what is necessary
        showError = false
        successMessage = ""
        errorMessage = ""
        isOTPVerified = false
        isRegistered = false
    }

    // MARK: - Reset Password
    func resetPassword(email: String, newPassword: String, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        print("Resetting password for email: \(email)")
        
        AuthService.shared.resetPassword(email: email, newPassword: newPassword) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        self?.successMessage = response.message
                        self?.showError = false
                        self?.isResetpassword = true
                        print("Password reset successfully: \(response.message)")
                        completion(true, response.message) // Success case
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                        print("Failed to reset password: \(response.message)")
                        completion(false, response.message) // Failure case
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.isResetpassword = false
                    self?.errorMessage = error.localizedDescription
                    print("Error resetting password: \(error.localizedDescription)")
                    completion(false, error.localizedDescription) // Failure case
                }
            }
        }
    }

    
}
