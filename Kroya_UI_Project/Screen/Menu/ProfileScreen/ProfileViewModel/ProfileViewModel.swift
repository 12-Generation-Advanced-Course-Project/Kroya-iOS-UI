//
//  ProfileViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import SwiftUI
import Alamofire

class ProfileViewModel: ObservableObject {
    @Published var userProfile: ProfileModel?
      @Published var isLoading: Bool = false
      @Published var successMessage: String = ""
      @Published var showError: Bool = false
      @Published var errorMessage: String = ""
      @Published var isUpdate: Bool = false
 
    // MARK: Fetch User Profile
    func fetchUserProfile() {
        self.isLoading = true
        ProfileService.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let grandUserProfile = response.payload {
                            self?.userProfile = grandUserProfile
                        }
                        self?.successMessage = "Profile fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }

    // MARK: Update User Profile
    func updateUserProfile(fullName: String, phoneNumber: String, address: String, profileImage: String?, completion: @escaping (Bool) -> Void) {
        self.isLoading = true

        let imageToUse = profileImage ?? userProfile?.profileImage ?? ""

        sendUpdateProfile(fullName: fullName, phoneNumber: phoneNumber, address: address, profileImageName: imageToUse, completion: completion)
         
    }

    //MARK: Function to handle updating the profile
       func sendUpdateProfile(fullName: String, phoneNumber: String, address: String, profileImageName: String, completion: @escaping (Bool) -> Void) {
           isLoading = true // Start loading indicator

           ProfileService.shared.sendUpdateProfileRequest(fullName: fullName, phoneNumber: phoneNumber, address: address, profileImageName: profileImageName) { [weak self] result in
               DispatchQueue.main.async {
                   guard let self = self else { return }
                   self.isLoading = false // Stop loading indicator

                   switch result {
                   case .success(let updatedProfile):
                       self.userProfile = updatedProfile // Update user profile
                       self.successMessage = "Profile updated successfully."
                       self.showError = false
                       self.isUpdate = true // Indicate a successful update
                       completion(true)
                   case .failure(let error):
                       self.errorMessage = "Failed to update profile: \(error.localizedDescription)"
                       self.showError = true
                       self.isUpdate = false
                       completion(false)
                   }
               }
           }
       }
    // MARK: Function to format the createdAt date
    func formatDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM yyyy"
            return "Since \(outputFormatter.string(from: date))"
        }
        return ""
    }
    
    func deleteProfile() {
        
        let url = "https://kroya-api-production.up.railway.app/api/v1/user/delete-account"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Accept": "*/*"
        ]
        
        AF.request(url, method: .delete, headers: headers).validate().response { response in
            DispatchQueue.main.async {
                self.isLoading = false // Stop loading indicator

                switch response.result {
                case .success:
                    self.successMessage = "Account deleted successfully."
                    self.showError = false
                    print("Account deletion success: \(response)")
                case .failure(let error):
                    self.errorMessage = "Failed to delete account: \(error.localizedDescription)"
                    self.showError = true
                    print("Account deletion error: \(error)")
                }
            }
        }
    }
    
}

