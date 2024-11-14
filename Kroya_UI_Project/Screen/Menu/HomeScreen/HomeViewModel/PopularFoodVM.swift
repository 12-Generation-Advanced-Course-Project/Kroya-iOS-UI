//
//  PopularFoodVM.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/11/24.
//
import SwiftUI
import Foundation

class PopularFoodVM: ObservableObject {
    @Published var popularFoodRecipe: [FoodRecipeModel] = []
    @Published var popularFoodSell: [FoodSellModel] = []
    @Published var popularFood: [PopularPayload] = []
    @Published var isLoading: Bool = false
    
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    //MARK: Computed property to get all popular food names
    var popularFoodNames: [String] {
        let recipeNames = popularFoodRecipe.map { $0.name }
        let sellNames = popularFoodSell.map { $0.name }
        return recipeNames + sellNames
    }
    private func startLoading(){
        isLoading = true
    }
    
    private func endLoading(){
        isLoading = false
    }
    
    //MARK: - get All Popular
    
    func getAllPopular() {
        startLoading()
        Foods_Service.shared.fetchAllPopular { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.popularFoodSell = payload.popularSells
                        self?.popularFoodRecipe = payload.popularRecipes
                        self?.successMessage = "Popular food fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to get popular food \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
}
