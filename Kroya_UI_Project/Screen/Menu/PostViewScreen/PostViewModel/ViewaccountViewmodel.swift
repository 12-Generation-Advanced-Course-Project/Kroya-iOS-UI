import SwiftUI
import Foundation

class ViewaccountViewmodel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var totalFoodRecipes: Int = 0
    @Published var totalFoodSells: Int = 0
    @Published var totalPosts: Int = 0
    @Published var UserFoodDataRecipe: [FoodRecipeModel] = []
    @Published var UserFoodDataFoodSell: [FoodSellModel] = []
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var profileImage: String = ""
    
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    
    //MARK: Fetch All User Food Data
    func fetchAllUserFoodData(userId: Int) {
        startLoading()
        ViewAccountService.shared.fetchAllUserDataFood(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.UserFoodDataRecipe = payload.foodRecipes
                        self?.UserFoodDataFoodSell = payload.foodSells
                        self?.totalFoodRecipes = payload.totalFoodRecipes
                        self?.totalFoodSells = payload.totalFoodSells
                        self?.totalPosts = payload.totalPosts
                        self?.fullName = payload.fullName
                        self?.email = payload.email
                        self?.profileImage = payload.profileImage
                        self?.successMessage = "User food data fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to fetch user food data: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
}
