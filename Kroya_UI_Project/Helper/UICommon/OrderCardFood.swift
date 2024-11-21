

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
                    
                    if let quantity = order.quantity {
                        Text("\(quantity) items")
                            .customFontLightLocalize(size: 12)
                            .opacity(0.6)
                    } else {
                        Text(order.foodCardType == "SALE" ? (order.dateCooking ?? "You are selling now") : (order.purchaseDate ?? "No Cooking Date Available"))
                            .customFontLightLocalize(size: 12)
                            .opacity(0.6)
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
        .buttonStyle(PlainButtonStyle()) // Optional: remove the default button styling
        
    }
}
