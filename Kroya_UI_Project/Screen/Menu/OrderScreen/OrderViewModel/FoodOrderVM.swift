
import SwiftUI
import Alamofire

class FoodSellViewModel: ObservableObject {
    @Published var foodSell: FoodSellModel?
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isUpdate: Bool = false

    // MARK: Fetch User Profile
    func fetchFoodSell() {
        self.isLoading = true
        FoodSellService.shared.getFoodSell { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let grandFoodsell = response.payload {
                            self?.foodSell = grandFoodsell
                        }
                        self?.successMessage = "Food Sell fetched successfully."
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
//    func updateUserProfile(fullName: String, phoneNumber: String, address: String, profileImage: String?, completion: @escaping (Bool) -> Void) {
//        self.isLoading = true
//
//        let imageToUse = profileImage ?? userProfile?.profileImage ?? ""
//
//        sendUpdateProfile(fullName: fullName, phoneNumber: phoneNumber, address: address, profileImageName: imageToUse, completion: completion)
//         
//    }
//
//    private func sendUpdateProfile(fullName: String, phoneNumber: String, address: String, profileImageName: String, completion: @escaping (Bool) -> Void) {
//        ProfileService.shared.sendUpdateProfileRequest(fullName: fullName, phoneNumber: phoneNumber, address: address, profileImageName: profileImageName) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let updatedProfile):
//                    // Assuming `updatedProfile.payload` is of type `ProfileModel`
//                    if let profile = updatedProfile.payload as? ProfileModel {
//                        self?.userProfile = profile
//                    } else {
//                        print("Payload is not of type ProfileModel")
//                    }
//                   
//                    self?.successMessage = "Profile updated successfully."
//                    self?.showError = false
//                    completion(true)
//                case .failure(let error):
//                    self?.showError = true
//                    self?.errorMessage = "Failed to update profile: \(error.localizedDescription)"
//                    print("Error: \(error)")
//                    completion(false)
//                }
//            }
//        }
//    }
//    
//    // MARK: Function to format the createdAt date
//    func formatDate(from dateString: String) -> String {
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//        
//        if let date = inputFormatter.date(from: dateString) {
//            let outputFormatter = DateFormatter()
//            outputFormatter.dateFormat = "MMMM yyyy"
//            return "Since \(outputFormatter.string(from: date))"
//        }
//        return ""
//    }
}

