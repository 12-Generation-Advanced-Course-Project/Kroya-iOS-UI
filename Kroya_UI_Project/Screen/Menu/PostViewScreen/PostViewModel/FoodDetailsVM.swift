//
//  FavoriteViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import SwiftUI

class FoodDetailsViewModel: ObservableObject {
    @Published var foodRecipeDetail: FoodRecipeDetail?
    @Published var foodSellDetail: FoodSellDetails?
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    private let service = Foods_Service.shared

    func fetchFoodDetails(id: Int, itemType: String) {
        isLoading = true
        showError = false

        service.getFoodDetails(id: id, itemType: itemType) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if let recipeResponse = response as? FoodDetailRecipeResponse {
                        self?.foodRecipeDetail = recipeResponse.payload
                        self?.foodSellDetail = nil // Clear if switching types
                    } else if let sellResponse = response as? FoodDetailSellResponse {
                        self?.foodSellDetail = sellResponse.payload
                        self?.foodRecipeDetail = nil // Clear if switching types
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    func fetchFoodDetailsForguest(id: Int, itemType: String) {
        isLoading = true
        showError = false

        GuestFoodPopularService.shared.getFoodDetailsForGuest(id: id, itemType: itemType) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if let recipeResponse = response as? FoodDetailRecipeResponse {
                        self?.foodRecipeDetail = recipeResponse.payload
                        self?.foodSellDetail = nil // Clear if switching types
                    } else if let sellResponse = response as? FoodDetailSellResponse {
                        self?.foodSellDetail = sellResponse.payload
                        self?.foodRecipeDetail = nil // Clear if switching types
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func getName() -> String {
        foodRecipeDetail?.name ?? foodSellDetail?.foodRecipeDTO.name ?? "Unknown"
    }

    func getDescription() -> String {
        foodRecipeDetail?.description ?? foodSellDetail?.foodRecipeDTO.description ?? "No description available"
    }

    func getImages() -> [String] {
        if let recipeDetail = foodRecipeDetail {
            return recipeDetail.photo.map { "https://kroya-api-production.up.railway.app/api/v1/fileView/\($0.photo)" }
        } else if let sellDetail = foodSellDetail {
            return sellDetail.foodRecipeDTO.photo.map { "https://kroya-api-production.up.railway.app/api/v1/fileView/\($0.photo)" }
        }
        return []
    }
}

