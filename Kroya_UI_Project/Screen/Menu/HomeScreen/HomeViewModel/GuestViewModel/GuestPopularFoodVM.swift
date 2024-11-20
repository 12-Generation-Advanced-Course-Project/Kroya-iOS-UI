import SwiftUI
import Foundation

class GuestPopularFoodVM: ObservableObject {
    @Published var guestPopularFoodRecipe: [FoodRecipeModel] = []
    @Published var guestPopularFoodSell: [FoodSellModel] = []
    @Published var popularFood: [PopularPayload] = []
    @Published var isLoading: Bool = false
    
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    //MARK: Computed property to get all popular food names
    var popularFoodNames: [String] {
        let recipeNames = guestPopularFoodRecipe.map { $0.name }
        let sellNames = guestPopularFoodSell.map { $0.name }
        return recipeNames + sellNames
    }
    private func startLoading(){
        isLoading = true
    }
    
    private func endLoading(){
        isLoading = false
    }
    
    //MARK: - get guest food popular
   
    func  getAllGuestPopular() {
        startLoading()
        GuestFoodPopularService.shared.fetchGuestFoodPopular{ [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.guestPopularFoodSell = payload.popularSells
                        self?.guestPopularFoodRecipe = payload.popularRecipes
                        self?.successMessage = "Guest popular food fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Guest failed to get popular food \(error.localizedDescription)"
                    print("Errorggg: \(error)")
                  //  debugPrint("KUromi", response)
                }
            }
        }
    }
    
    
}
