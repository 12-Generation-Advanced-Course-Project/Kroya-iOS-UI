//
//  AuthViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 12/10/24.
//

import SwiftUI
import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isEmailExist: Bool = false
    @Published var showError: Bool = false
    @Published var successMessage: String = ""
    @Published var errorMessage: String = ""
    @Published var isOTPSent: Bool = false
    @Published var isOTPVerified: Bool = false
    @Published var isRegistered: Bool = false
    @ObservedObject private var countdownTimer = CountdownTimer()
    @ObservedObject var userStore: UserStore
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
                    // Check if there's an error in the response
                    if response.statusCode == "200" {
                        // Email exists
                        self?.isEmailExist = true
                        self?.showError = false
                        self?.successMessage = response.message
                        print("Email exists: \(response.message)")
                    }
                  
                    
                case .failure(let error):
                    // Email does not exist, proceed to send OTP
                    self?.isEmailExist = false
                    print("Email not registered. Sending OTP...")
                    self?.sendOTP(email: email) { success in
                        if success {
                            print("OTP sent successfully.")
                            // Start the countdown timer if necessary
                        } else {
                            // Handle failure to send OTP
                            self?.showError = true
                            self?.errorMessage = "Failed to send OTP. Please try again."
                            print("Failed to send OTP.")
                        }
                    }
                    self?.userStore.setUser(email: email)
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                    print("\(error.localizedDescription)")
                   
                }
            }
        }
    }

    // MARK: Function to send OTP
     func sendOTP(email: String,completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        print("Sending OTP to: \(email)")
        AuthService.shared.sendOTP(email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    self?.successMessage = "OTP sent successfully. Please check your email."
                    self?.isOTPSent = true  // OTP has been sent
                    self?.showError = false
                    print("OTP sent successfully.")
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
        guard newPassword == confirmPassword else {
            self.showError = true
            self.successMessage = "Passwords do not match."
            return
        }
        self.isLoading = true
        print("Passwords match. Proceeding to create the password...")
        AuthService.shared.createPassword(email: email, password: newPassword, confirmPassword: confirmPassword) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.isRegistered = true
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let tokenPayload = response.payload {
                            let accessToken = tokenPayload.access_token
                            let refreshToken = tokenPayload.refresh_token
                           
                            // Store the tokens in the user model or handle them as needed
                            print("Access Token: \(accessToken)")
                            print("Refresh Token: \(refreshToken)")
                        }
                        print("Register account successful")
                        self?.successMessage = "Register account SuccessFull"
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


}
