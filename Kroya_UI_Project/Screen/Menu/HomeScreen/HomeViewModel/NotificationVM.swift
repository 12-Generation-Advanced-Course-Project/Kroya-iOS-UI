////
////  NotificationVM.swift
////  Kroya_UI_Project
////
////  Created by KAK-LY on 22/11/24.
////
//
//import SwiftUI
//
//class NotificationViewModel: ObservableObject {
//    
//    @Published var notifications: [NotificationModel] = []
//    @Published var isLoading: Bool = false
//    @Published var successMessage: String = ""
//    @Published var showError: Bool = false
//    @Published var errorMessage: String = ""
//    @Published var isUpdate: Bool = false
//    
//    // MARK: - Helper Methods for Loading State
//    private func startLoading() {
//        isLoading = true
//    }
//    
//    private func endLoading() {
//        isLoading = false
//    }
//    
//        //MARK: fetch Notification
//        func fetchNotifications() {
//            self.startLoading()
//            NotificationService.shared.getNotifications { [weak self] result in
//                DispatchQueue.main.async {
//                    self!.endLoading()
//                    switch result {
//                    case .success(let response):
//                        if response.statusCode == "200", let payload = response.payload {
//                            self?.notifications = payload
//                        }else {
//                            print("Error fetching purchase: \(response.message)")
//                        }
//                    case .failure(let error):
//                        self?.errorMessage = "Failed to fetch purchases: \(error.localizedDescription)"
//                        print("Error: \(error)")
//                    }
//                }
//            }
//        }
//    
//    
//}
//
//



import SwiftUI

class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var newNotifications: [NotificationModel] = []
    @Published var olderNotifications: [NotificationModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    // Computed property to count today's notifications
      var todayNotificationCount: Int {
          newNotifications.count
      }

      // Helper to parse dates
      private func parseDate(from string: String) -> Date? {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
          formatter.timeZone = .current
          return formatter.date(from: string)
      }
    
    func fetchNotifications() {
        NotificationService.shared.getNotifications { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.notifications = payload
                        print("Fetched Notifications: \(payload)") // Debug
                        self?.filterNotifications()
                    } else {
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    
//    private func filterNotifications() {
//        let today = Calendar.current.startOfDay(for: Date())
//        
//        newNotifications = notifications.filter { notification in
//            guard let date = parseDate(from: notification.createdDate) else { return false }
//            return Calendar.current.isDateInToday(date)
//        }
//        
//        olderNotifications = notifications.filter { notification in
//            guard let date = parseDate(from: notification.createdDate) else { return false }
//            return date < today
//        }
//    }
    
    
    private func filterNotifications() {
        let today = Calendar.current.startOfDay(for: Date())
        
        // New Notifications: Today and Future
        newNotifications = notifications.filter { notification in
            guard let date = parseDate(from: notification.createdDate) else { return false }
            return date >= today
        }
        
        // Older Notifications: Past
        olderNotifications = notifications.filter { notification in
            guard let date = parseDate(from: notification.createdDate) else { return false }
            return date < today 
        }
    }
    
    

    
}
