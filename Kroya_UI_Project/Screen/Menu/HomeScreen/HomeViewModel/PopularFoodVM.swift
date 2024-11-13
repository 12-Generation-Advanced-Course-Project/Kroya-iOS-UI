//
//  PopularFoodVM.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/11/24.
//
import SwiftUI
import Foundation

class PopularFoodVM: ObservableObject {
    @Published var popularFood: [PopularFoodItem] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
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
                    if response.statusCode == "200" {
                        // Access the payload directly without optional binding
                        let payload = response.payload
                        self?.popularFood = payload.popularSells.map { PopularFoodItem.sell($0) } + payload.popularRecipes.map { PopularFoodItem.recipe($0) }
                        self?.successMessage = "Popular Food Fetched successfullyy."
                        self?.showError = false
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
