import SwiftUI
import Alamofire

class FoodSellViewModel: ObservableObject {
    
    @Published var FoodOnSale: [FoodSellModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    // MARK: Fetch User CardSell
    func getAllFoodSell() {
        self.isLoading = true
        FoodSellService.shared.fetchAllCardFood { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let payload = response.payload {
                            self?.FoodOnSale = payload // Update FoodOnSale here
                        }
                        self?.successMessage = "FoodCard fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load FoodCard: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: Post New Food Sell
    func createFoodSell(foodSellRequest: FoodSellRequest, foodRecipeId: Int, currencyType: String) {
        self.isLoading = true
        FoodSellService.shared.postFoodSell(foodSellRequest, foodRecipeId: foodRecipeId, currencyType: currencyType) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "201" {
                        self?.successMessage = "Food sell posted successfully."
                        self?.showError = false
                        // Optionally refresh the list if you want to show the new item
                        self?.getAllFoodSell()
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to post food sell: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
}
