import SwiftUI
struct NotificationView: View {
    @StateObject private var viewModel = NotificationViewModel()
    let sellerId: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if !viewModel.newNotifications.isEmpty {
                        Text("New")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 4)
                        
                        ForEach(viewModel.newNotifications) { notification in
                            NotificationComponent(notification: notification, sellerId: notification.foodSellId)
                        }
                    } else {
                        Text("New")
                        Text("Empty Notification")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    if !viewModel.olderNotifications.isEmpty {
                        Text("Older")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 4)
                        
                        ForEach(viewModel.olderNotifications) { notification in
                            NotificationComponent(notification: notification, sellerId: notification.foodSellId)
                            
                        }
                    } else {
                        Text("Older")
                        Text("Empty Notification")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.top, 15)
                .padding(.horizontal, 10)
            }
            .scrollIndicators(.hidden)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Notifications")
                        .fontWeight(.semibold)
                    HStack {
                        Text("You have")
                        Text("\(viewModel.todayNotificationCount) Notifications")
                            .foregroundStyle(.yellow)
                        Text("new")
                    }
                    .font(.custom("HelveticaNeue-Regular", size: 12))
                    .foregroundStyle(.black.opacity(0.6))
                }
                .padding(.leading, -20)
            }
        }
        .onAppear {
            viewModel.fetchNotifications()
            print("Seller ID in NotificationView: \(sellerId)") // Debug
        }
    }
}

