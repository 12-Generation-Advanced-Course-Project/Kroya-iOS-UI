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
        print("Verifying OTP for: \(email)")
        
        AuthService.shared.VerifyOTPCode(email, code) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        self?.successMessage = "OTP verified successfully."
                        self?.isOTPSent = false
                        self?.showError = false
                        self?.isOTPVerified = true
                        print("OTP verified successfully.")
                    } else if response.statusCode == "400" {
                        self?.errorMessage = response.message
                        self?.showError = true
                        print("Error: \(response.message)")
                        print("OTP is Invalid. Please try again.")
                    } else {
                        // Handle unexpected status codes
                        self?.errorMessage = "An unknown error occurred. Please try again."
                        self?.showError = true
                        print("Unknown error occurred.")
                    }
                    
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                    print("Error verifying OTP: \(error.localizedDescription)")
                }
            }
        }
    }

}
