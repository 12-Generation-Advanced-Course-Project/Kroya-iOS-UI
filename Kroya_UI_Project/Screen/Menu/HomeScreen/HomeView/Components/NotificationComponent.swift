//import SwiftUI
//import SDWebImageSwiftUI
//
//struct NotificationComponent: View {
//    
//    var notification: NotificationModel
//    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
//    
//    var body: some View {
//        VStack{
//            HStack(alignment: .center, spacing: 8) {
//                ZStack(alignment: .topLeading) {
//                    if let url = URL(string: urlImagePrefix + notification.foodPhoto) {
//                        WebImage(url: url)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 50, height: 50)
//                            .cornerRadius(8)
//                    } else {
//                        Image(systemName: "photo")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 50, height: 50)
//                            .cornerRadius(8)
//                    }
//                }
//                
//                VStack(alignment: .leading, spacing: 2) {                     Text(notification.description)
//                        .font(.system(size: 14, weight: .medium))
//                    
//                    Text(formatTimeAgo(from: notification.createdDate))
//                        .font(.system(size: 12))
//                        .foregroundColor(.gray)
//                }
//                
//                Spacer()
//                
//                Circle()
//                    .fill(Color.yellow)
//                    .frame(width: 8, height: 8)
//            }
//        }
//        .padding(.horizontal, 4)
//        Divider()
//            .padding(.horizontal, 4)
//    }
//    
//    // MARK: - Helper Functions
//    private func formatTimeAgo(from dateString: String) -> String {
//        guard let date = parseDate(dateString) else {
//            return "Invalid Date"
//        }
//        
//        let now = Date()
//        let timeInterval = now.timeIntervalSince(date)
//        
//        let calendar = Calendar.current
//        let todayStart = calendar.startOfDay(for: now)
//        let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: todayStart)!
//        
//        let minutesAgo = Int(timeInterval / 60) // Convert seconds to minutes
//        let hoursAgo = Int(timeInterval / 3600) // Convert seconds to hours
//
//        if calendar.isDateInToday(date) {
//            if minutesAgo < 1 {
//                return "Just now"
//            } else if minutesAgo < 60 {
//                return "\(minutesAgo) m ago"
//            } else {
//                return "\(hoursAgo) h ago"
//            }
//        } else if calendar.isDate(date, inSameDayAs: yesterdayStart) {
//            return formatDateToDDMMYY(date)
//        } else {
//            return formatDateToDDMMYY(date)
//        }
//    }
//
//    private func parseDate(_ dateString: String) -> Date? {
//        let dateFormats = [
//            "yyyy-MM-dd'T'HH:mm:ss.SSS",
//            "yyyy-MM-dd'T'HH:mm:ss"
//        ]
//        
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        
//        for format in dateFormats {
//            formatter.dateFormat = format
//            if let date = formatter.date(from: dateString) {
//                return date
//            }
//        }
//        return nil
//    }
//    
//    private func formatDateToDDMMYY(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yy"
//        return formatter.string(from: date)
//    }
//}
//







import SwiftUI
import SDWebImageSwiftUI

struct NotificationComponent: View {
    
    let notification: NotificationModel
    @StateObject private var orderRequestVM = OrderRequestViewModel()
    var sellerId:Int
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    
    var body: some View {
        NavigationLink(destination: getDestinationView()) {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 8) {
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
                    
                    // Unread Indicator
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
        }
    }

    
    // MARK: - Destination View
    @ViewBuilder
    private func getDestinationView() -> some View {
        if notification.foodCardType == "SALE" {
            OrderListView(sellerId: sellerId, orderCountText: "5")
        } else if notification.foodCardType == "ORDER" {
            FoodDetailView(
                isFavorite: false,
                showPrice: true,
                showOrderButton: true,
                showButtonInvoic: nil,
                invoiceAccept: nil,
                FoodId: notification.foodSellID,
                ItemType: notification.itemType
            )
        } else {
            Text("Unknown destination")
        }
    }
    
    
     //MARK: - Helper Functions
        private func formatTimeAgo(from dateString: String) -> String {
            guard let date = parseDate(dateString) else {
                return "Invalid Date"
            }
    
            let now = Date()
            let timeInterval = now.timeIntervalSince(date)
    
            let calendar = Calendar.current
            let todayStart = calendar.startOfDay(for: now)
            let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: todayStart)!
    
            let minutesAgo = Int(timeInterval / 60) // Convert seconds to minutes
            let hoursAgo = Int(timeInterval / 3600) // Convert seconds to hours
    
            if calendar.isDateInToday(date) {
                if minutesAgo < 1 {
                    return "Just now"
                } else if minutesAgo < 60 {
                    return "\(minutesAgo) m ago"
                } else {
                    return "\(hoursAgo) h ago"
                }
            } else if calendar.isDate(date, inSameDayAs: yesterdayStart) {
                return formatDateToDDMMYY(date)
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
