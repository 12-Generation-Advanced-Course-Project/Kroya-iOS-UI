
import SwiftUI
import Kingfisher

struct OrderCard: View {
    
    var order: OrderModel
    var showIcon: Bool
    @State private var navigateToDestination = false
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    
    private var orderCountText: String {
        "\(order.orderCount ?? 0)" // Safely unwrap and convert to string
    }
    
    var body: some View {
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
                    // Order name
                    Text(order.name)
                        .font(.system(size: 15, weight: .medium))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Status or Icon
                    // Status or Icon
                    if order.foodCardType == "ORDER" {
                        Group {
                            if order.purchaseStatusType == "PENDING" {
                                Text("Pending")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.orange)
                                    .onTapGesture {
                                        // Provide feedback that navigation is disabled
                                        print("This order is pending and cannot be navigated.")
                                    }
                            } else {
                                Text(
                                    order.purchaseStatusType == "ACCEPTED" ? "Accepted" :
                                        order.purchaseStatusType == "REJECTED" ? "Rejected" :
                                        "Unknown Status"
                                )
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(
                                    order.purchaseStatusType == "ACCEPTED" ? .green :
                                        order.purchaseStatusType == "REJECTED" ? .red :
                                            .gray
                                )
                                .onTapGesture {
                                    navigateToDestination = true
                                }
                            }
                        }
                    }
                    else if order.foodCardType == "SALE", showIcon {
                        Button(action: {
                            navigateToDestination = true
                        }) {
                            ZStack {
                                Image(systemName: "list.clipboard")
                                    .foregroundColor(.gray)
                                Text(orderCountText)
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Circle().fill(Color.red))
                                    .offset(x: 8, y: -6)
                            }
                        }
                    }
                }
                
                if order.foodCardType == "SALE" {
                    HStack {
                        if let quantity = order.quantity {
                            Text("\(quantity) items")
                                .font(.system(size: 12, weight: .light))
                                .opacity(0.6)
                        } else {
                            Text("No quantity specified")
                                .font(.system(size: 12, weight: .light))
                                .opacity(0.6)
                        }
                        Text("Item selling now")
                            .font(.system(size: 12, weight: .light))
                            .opacity(0.6)
                    }
                } else if order.foodCardType == "ORDER" {
                    HStack {
                        if let quantity = order.quantity {
                            Text("\(quantity) items")
                                .font(.system(size: 12, weight: .light))
                                .opacity(0.6)
                        } else {
                            Text("No quantity specified")
                                .font(.system(size: 12, weight: .light))
                                .opacity(0.6)
                        }
                        Spacer()
                    }
                }
                
                HStack(spacing: 15) {
                    Text(order.foodCardType == "ORDER" ?
                         "៛\(order.totalPrice ?? 0)" : // Show totalPrice for orders
                         "៛\(order.price ?? 0)" // Show price for sales
                    )
                    .font(.system(size: 15, weight: .medium))
                    
                    Text(order.foodCardType)
                        .font(.system(size: 12, weight: .medium))
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
        .background(
            NavigationLink(
                destination: destinationView(for: order),
                isActive: $navigateToDestination
            ) {
                EmptyView()
            }
        )
        .padding(.vertical, 7)
        .padding(.horizontal, 12)
        .frame(width: 360)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                .background(Color.white.cornerRadius(12))
        )
    }
    
    //MARK: Helper function to determine destination dynamically
    @ViewBuilder
    private func destinationView(for order: OrderModel) -> some View {
        if order.purchaseStatusType != "PENDING" {
            if order.foodCardType == "ORDER" {
                FoodDetailView(
                    isFavorite: false,
                    showPrice: true,
                    showOrderButton: false,
                    showButtonInvoic: "true",
                    invoiceAccept: order.purchaseStatusType,
                    FoodId: order.foodSellId,
                    ItemType: order.itemType,
                    PurchaseId: order.purchaseID
                )
            } else if order.foodCardType == "SALE" {
                OrderListView(
                    sellerId: order.foodSellId,
                    orderCountText: "\(order.orderCount ?? 0)"
                )
            } else {
                EmptyView()
            }
        }
    }
    
    
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

