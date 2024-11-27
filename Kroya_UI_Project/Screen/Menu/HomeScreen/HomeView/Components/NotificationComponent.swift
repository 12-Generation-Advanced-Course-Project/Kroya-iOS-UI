import SwiftUI
import SDWebImageSwiftUI


struct NotificationComponent: View {
    let notification: NotificationModel
    let sellerId: Int
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    
    @State private var isActive: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 8) {
                // Image Section
                ZStack(alignment: .topLeading) {
                    if let url = URL(string: urlImagePrefix + notification.foodPhoto) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    }
                }
                
                // Text Section
                VStack(alignment: .leading, spacing: 2) {
                    Text(notification.description)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text(formatTimeAgo(from: notification.createdDate))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Yellow indicator for unread notifications
                if !notification.isRead {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 10, height: 10)
                }
            }
            Divider()
                .padding(.top, 4)
        }
        .padding(.horizontal, 8)
        .background(
            NavigationLink(
                destination: getDestinationView(),
                isActive: $isActive,
                label: { EmptyView() }
            )
            .hidden()
        )
        .onTapGesture {
            markNotificationAsRead()
            isActive = true
        }
    }
    
    // MARK: - Destination View
    @ViewBuilder
    private func getDestinationView() -> some View {
        switch notification.foodCardType {
        case "SALE":
            OrderListView(sellerId: sellerId, orderCountText: "5")
        case "ORDER":
            FoodDetailView(
                isFavorite: false,
                showPrice: true,
                showOrderButton: false,
                showButtonInvoic: "true",
                invoiceAccept: "ACCEPTED",
                FoodId: notification.foodSellId,
                ItemType: notification.itemType,
                PurchaseId: notification.purchaseID
            )
        default:
            Text("Unknown destination")
        }
    }
    
    // MARK: - Mark Notification as Read
    private func markNotificationAsRead() {
        if !notification.isRead {
            print("Notification marked as read for ID: \(notification.notificationID)") // Debug log
            // Add API call here if needed to persist the state
        }
    }
    
    // MARK: - Helper Functions
    private func formatTimeAgo(from dateString: String) -> String {
        guard let date = parseDate(dateString) else {
            return "Invalid Date"
        }
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: now)
        
        let minutesAgo = Int(timeInterval / 60) // Convert seconds to minutes
        let hoursAgo = Int(timeInterval / 3600) // Convert seconds to hours
        
        // Check if date is today
        if calendar.isDateInToday(date) {
            if minutesAgo < 1 {
                return "Just now"
            } else if minutesAgo < 60 {
                return "\(minutesAgo) m ago"
            } else {
                return "\(hoursAgo) h ago"
            }
        } else if date >= todayStart {
            return "Later Today"
        } else {
            return formatDateToDDMMYY(date)
        }
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss"
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    
    private func formatDateToDDMMYY(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}
