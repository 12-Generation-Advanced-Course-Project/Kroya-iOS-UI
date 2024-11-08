import SwiftUI
import Alamofire

class FoodSellViewModel: ObservableObject {
    
    @Published var foodCard: [FoodSellModel] = []
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
                            self?.foodCard = payload
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
}


