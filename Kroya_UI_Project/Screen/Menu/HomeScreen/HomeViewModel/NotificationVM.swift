//
//  NotificationVM.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 22/11/24.
//

import SwiftUI

class NotificationViewModel: ObservableObject {
    
    @Published var notifications: [NotificationModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isUpdate: Bool = false
    
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    
        //MARK: fetch Notification
        func fetchNotifications() {
            self.startLoading()
            NotificationService.shared.getNotifications { [weak self] result in
                DispatchQueue.main.async {
                    self!.endLoading()
                    switch result {
                    case .success(let response):
                        if response.statusCode == "200", let payload = response.payload {
                            self?.notifications = payload
                        }else {
                            print("Error fetching purchase: \(response.message)")
                        }
                    case .failure(let error):
                        self?.errorMessage = "Failed to fetch purchases: \(error.localizedDescription)"
                        print("Error: \(error)")
                    }
                }
            }
        }
    
    
}










