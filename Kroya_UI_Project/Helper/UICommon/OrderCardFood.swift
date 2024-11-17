
import SwiftUI
import Kingfisher

struct OrderCard: View {
    
    var order: OrderModel // Accept an OrderModel instance
    var isAccepted: Bool
    var isOrder: Bool
    var showIcon: Bool
    @State private var navigateToOrderListView = false
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    
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
                    Text(order.name) // Display the order name
                        .customFontMediumLocalize(size: 15)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Conditional rendering based on order type
                    //                    if order.foodCardType == "ORDER" {
                    //                        Text(order.itemType == "Accept" ? "Accept" : "Reject")
                    //                            .customFontMediumLocalize(size: 15)
                    //                            .foregroundColor(isAccepted ? .green : .red)
                    //                    }
                    if order.foodCardType == "ORDER" {
                        if let status = order.purchaseStatusType {
                            switch status {
                            case "ACCEPT":
                                Text("Accept")
                                    .customFontMediumLocalize(size: 15)
                                    .foregroundColor(.green)
                            case "REJECT":
                                Text("Reject")
                                    .customFontMediumLocalize(size: 15)
                                    .foregroundColor(.red)
                            case "PENDING":
                                Text("Pending")
                                    .customFontMediumLocalize(size: 15)
                                    .foregroundColor(.orange)
                            default:
                                Text("Unknown")
                                    .customFontMediumLocalize(size: 15)
                                    .foregroundColor(.gray)
                            }
                        }
                    } else if order.foodCardType == "SALE" {
                        if showIcon {
                            Button(action: {
                                navigateToOrderListView = true
                            }) {
                                ZStack {
                                    Image(systemName: "list.clipboard")
                                        .foregroundColor(.gray)
                                    Text("\(order.quantity ?? 0)") // Safely unwrap optional
                                        .customFontSemiBoldLocalize(size: 9)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Circle().fill(Color.red))
                                        .offset(x: 8, y: -6)
                                }
                            }
                            .background(
                                NavigationLink(destination: OrderListView(), isActive: $navigateToOrderListView) {
                                    EmptyView()
                                }
                            )
                        }
                    }
                }
                
                //                Text("You are selling now")
                //                    .customFontLightLocalize(size: 12)
                //                    .opacity(0.6)
                
                // Conditional rendering of text
                if order.foodCardType != "ORDER" {
                    Text("You are selling now")
                        .customFontLightLocalize(size: 12)
                        .opacity(0.6)
                } else {
                    EmptyView() // Removes the text entirely when condition is not met
                    //                    Text("")
                }
                
                
                HStack(spacing: 15) {
                    Text("$\(order.totalPrice ?? 0)") // Safely unwrap optional
                        .customFontMediumLocalize(size: 15)
                        .fontWeight(.medium)
                    
                    Text(order.foodCardType)
                        .customFontMediumLocalize(size: 12)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(order.foodCardType == "ORDER" ? Color.yellow.opacity(0.2) : Color.green.opacity(0.2)) // Set background color based on type
                        )
                        .foregroundColor(order.foodCardType == "ORDER" ? Color.yellow : Color.green) // Set text color based on type
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
}
