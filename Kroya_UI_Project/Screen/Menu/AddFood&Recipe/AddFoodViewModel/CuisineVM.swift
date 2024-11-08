//
//  CuisineVM.swift
//  Kroya_UI_Project
//
//  Created by kosign on 7/11/24.
//

import SwiftUI
import Alamofire

class CuisineVM: ObservableObject {
    
    @Published var cuisineShowModel : [CuisinesModel] = []

    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
   
    // MARK: Fetch Cuisines
    func fetchAllCuisines() {
        self.isLoading = true
        CuisineService.shared.getCuisine { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let payload = response.payload {
                            
                            print("data payload \(payload)")
                            
//                            self?.cuisineShowModel = payload  // Directly assign the array
                            self?.cuisineShowModel = payload
                            
                        }
                        self?.successMessage = "Cuisine fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load cuisines: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
}

