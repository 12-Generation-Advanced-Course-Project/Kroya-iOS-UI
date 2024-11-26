//import SwiftUI
//
//struct NotificationView: View {
//    
//    @StateObject private var viewModel = NotificationViewModel()
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    // New Notifications
//                    if !viewModel.newNotifications.isEmpty {
//                        Text("New")
//                            .font(.system(size: 16, weight: .semibold))
//                            .padding(.leading, 4)
//                        
//                        ForEach(viewModel.newNotifications) { notification in
//                            NotificationComponent(notification: notification)
//                        }
//                    }
//                    
//                    // Older Notifications
//                    if !viewModel.olderNotifications.isEmpty {
//                        Text("Older")
//                            .font(.system(size: 16, weight: .semibold))
//                            .padding(.leading, 4)
//                        
//                        ForEach(viewModel.olderNotifications) { notification in
//                            NotificationComponent(notification: notification)
//                        }
//                    }
//                }
//                .padding(.top, 20)
//                .padding(.horizontal, 10)
//            }
//            .scrollIndicators(.hidden)
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                VStack(alignment: .leading, spacing: 5){
//                    Text("Notifications")
//                        .fontWeight(.semibold)
//                    HStack {
//                        Text(LocalizedStringKey("You have"))
//                        Text("\(viewModel.notifications.count) Notifications")
//                            .foregroundStyle(.yellow)
//                        Text(LocalizedStringKey("Today"))
//                    }
//                    .font(.custom("HelveticaNeue-Regular", size: 12))
//                    .foregroundStyle(.black.opacity(0.6))
//                }
//                .padding(.top, 10)
//                .padding(.leading, -20)
//            }
//        }
//        .padding(.vertical, 12)
//
//        .onAppear {
//            viewModel.fetchNotifications()
//        }
//    }
//}


import SwiftUI

struct NotificationView: View {
    
    @StateObject private var viewModel = NotificationViewModel()
    var sellerId:Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // New Notifications
                    if !viewModel.newNotifications.isEmpty {
                        Text("New")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 4)
                        
                        ForEach(viewModel.newNotifications) { notification in
                            NotificationComponent(notification: notification, sellerId: sellerId)
                        }
                    } else if viewModel.newNotifications.isEmpty && viewModel.olderNotifications.isEmpty {
                        Text("Empty Notification")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    // Older Notifications
                    if !viewModel.olderNotifications.isEmpty {
                        Text("Older")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 4)
                        
                        ForEach(viewModel.olderNotifications) { notification in
                            NotificationComponent(notification: notification, sellerId: sellerId)
                        }
                    } else if viewModel.newNotifications.isEmpty && viewModel.olderNotifications.isEmpty {
                        Text("Empty Notification")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 10)
            }
            .scrollIndicators(.hidden)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                VStack(alignment: .leading, spacing: 5){
                    Text("Notifications")
                        .fontWeight(.semibold)
                    HStack {
                        Text(LocalizedStringKey("You have"))
                        Text("\(viewModel.todayNotificationCount) Notifications")
                            .foregroundStyle(.yellow)
                        Text(LocalizedStringKey("Today"))
                    }
                    .font(.custom("HelveticaNeue-Regular", size: 12))
                    .foregroundStyle(.black.opacity(0.6))
                }
                .padding(.top, 10)
                .padding(.leading, -20)
            }
        }
        .padding(.vertical, 12)
        
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
}






