

import SwiftUI
import Kingfisher

struct OrderCard: View {
    
    var order: OrderModel
    var isAccepted: Bool
    var isOrder: Bool
    var showIcon: Bool
    @State private var navigateToOrderListView = false
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    
    private var orderCountText: String {
        "\(order.orderCount ?? 0)" // Safely unwrap and convert to string
    }
    
    var body: some View {
        
        NavigationLink(
            destination: OrderListView(sellerId: order.foodSellId, orderCountText: orderCountText),
            isActive: $navigateToOrderListView
        ) {
            HStack {
                // Display the first photo from the order if available using KFImage
                if let photoFilename = order.photo.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 61, height: 62)
                        .cornerRadius(8)
                } else {
                    Image(systemName: "photo") // Fallback image
                        .resizable()
                        .frame(width: 61, height: 62)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(order.name)
                            .customFontMediumLocalize(size: 15)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        Spacer()
                        
                        if order.foodCardType == "ORDER" {
                            Text(
                                order.purchaseStatusType == "ACCEPTED" ? "Accepted" :
                                    order.purchaseStatusType == "REJECTED" ? "Rejected" :
                                    order.purchaseStatusType == "PENDING" ? "Pending" :
                                    "Unknown Status"
                            )
                            .customFontMediumLocalize(size: 15)
                            .foregroundColor(
                                order.purchaseStatusType == "ACCEPTED" ? .green :
                                    order.purchaseStatusType == "REJECTED" ? .red :
                                    order.purchaseStatusType == "PENDING" ? .orange :
                                        .gray
                            )
                        } else if order.foodCardType == "SALE" {
                            if showIcon {
                                Button(action: {
                                    navigateToOrderListView = true
                                }) {
                                    ZStack {
                                        Image(systemName: "list.clipboard")
                                            .foregroundColor(.gray)
                                        Text(orderCountText)
                                            .customFontSemiBoldLocalize(size: 9)
                                            .foregroundColor(.white)
                                            .padding(4)
                                            .background(Circle().fill(Color.red))
                                            .offset(x: 8, y: -6)
                                    }
                                }
                            }
                        }
                    }
                    
                    if order.foodCardType == "SALE" {
                        HStack {
                            Text("Item selling now")
                                .customFontLightLocalize(size: 12)
                                .opacity(0.6)
                        }
                    } else if order.foodCardType == "ORDER" {
                        HStack {
                            if let quantity = order.quantity {
                                Text("\(quantity) items")
                                    .customFontLightLocalize(size: 12)
                                    .opacity(0.6)
                            } else {
                                Text("No quantity specified")
                                    .customFontLightLocalize(size: 12)
                                    .opacity(0.6)
                            }
                            Spacer()
                        }
                    }
                    
                    
                    HStack(spacing: 15) {
                        Text(order.foodCardType == "ORDER" ?
                             "$\(order.totalPrice ?? 0)" : // Show totalPrice for orders
                             "$\(order.price ?? 0)" // Show price for sales
                        )
                        .customFontMediumLocalize(size: 15)
                        .fontWeight(.medium)
                        
                        Text(order.foodCardType)
                            .customFontMediumLocalize(size: 12)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(order.foodCardType == "ORDER" ? Color.yellow.opacity(0.2) : Color.green.opacity(0.2))
                            )
                            .foregroundColor(order.foodCardType == "ORDER" ? Color.yellow : Color.green)
                    }
                }
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 12)
            .frame(width: 360)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    .background(Color.white.cornerRadius(12))
            )
        }
        .buttonStyle(PlainButtonStyle())
        
    }
    //MARK: Helper function to format date
    private func parseDate(_ dateString: String) -> Date? {
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS",  // With milliseconds
            "yyyy-MM-dd'T'HH:mm:ss"       // Without milliseconds
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
        return nil // Return nil if none of the formats match
    }
    
    
    //MARK: Helper function to determine time of day based on the cook date time (if available)
    private func formatDate(_ dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "Invalid Date" }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // Output format
        formatter.dateFormat = "dd MMM yyyy" // Example: "23 Nov 2024"
        return formatter.string(from: date)
    }
    
    private func determineTimeOfDay(from dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "at current time." }
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 5..<12:
            return "in the morning."
        case 12..<17:
            return "in the afternoon."
        case 17..<21:
            return "in the evening."
        default:
            return "at night."
        }
    }
}
