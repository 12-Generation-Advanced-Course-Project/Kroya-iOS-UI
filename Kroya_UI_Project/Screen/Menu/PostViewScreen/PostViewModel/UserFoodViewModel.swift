//
//  UserFoodViewModel.swift
//  Kroya_UI_Project
//
//  Created by kosign on 8/11/24.
//

import SwiftUI
import Alamofire

class UserFoodViewModel: ObservableObject{
    
    @Published var userFoodModel : [UserFoodModel] = []
    
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMesssage: String = ""
    
    //MARK: Fetch User Foods
    func fetchAllUserFoods(){
        self.isLoading = true
        UserFoodService.shared.getAllUserFood{ [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let payload = response.payload {
                                                        
                            self?.userFoodModel = payload
                        }
                        self?.successMessage = "User foods fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMesssage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMesssage = "Failed to load user foods: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
}
