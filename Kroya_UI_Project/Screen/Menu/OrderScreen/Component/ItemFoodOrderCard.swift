

import SwiftUI

struct ItemFoodOrderCard: View {
    
    var orderRequest: OrderRequestModel
    var showEllipsis: Bool = true // Default to true for other uses
    @State private var showPopover = false
    @Binding var show3dot: Bool
    let Keyaccept = "Accept"
    let Keyreject = "Reject"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                // Food image
                Image("brohok")
                    .resizable()
                    .frame(width: 65, height: 65)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 8) {
                        // Food name
                        Text(orderRequest.foodSellCardResponse.name)
                            .font(.customfont(.semibold, fontSize: 17))
                            .foregroundColor(.black)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(orderRequest.purchaseStatusType == Keyaccept ? Color(hex: "#DDF6C3") : (orderRequest.purchaseStatusType == Keyreject ? Color(hex: "#FFD8E4") : Color.clear))
                                .frame(width: 50, height: 23)
                            if show3dot == true {
                                Text(
                                    orderRequest.purchaseStatusType == "ACCEPTED" ? "Accepted" :
                                        orderRequest.purchaseStatusType == "REJECTED" ? "Rejected" :
                                        orderRequest.purchaseStatusType == "PENDING" ? "Pending" :
                                        "Unknown Status"
                                )
                                Text(orderRequest.purchaseStatusType != nil ? (orderRequest.purchaseStatusType == "Accept" ? "Accept" : "Reject") : "")
                                    .font(.customfont(.regular, fontSize: 12))
                                    .foregroundColor(orderRequest.purchaseStatusType == "Accept" ? .green : (orderRequest.purchaseStatusType == "Reject" ? .red : .clear))
                            }
                        }
                        Spacer()
                        
                        // Time
                        if let timeAgo = orderRequest.purchaseDate {
                            Text(formatTimeAgo(from: timeAgo))
                            .font(.customfont(.semibold, fontSize: 12))
                                .foregroundColor(.gray)
                        }
                        
                        // Conditionally render the ellipsis button based on `showEllipsis`
                        if showEllipsis {
                            Button(action: {
                                showPopover = true
                            }, label: {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90)) // Rotate to make it vertical
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .popover(isPresented: $showPopover, attachmentAnchor: .point(.topLeading), content: {
                                        VStack(spacing: 8) {
                                            Button("Accept", action: {
                                                orderRequest.purchaseStatusType
                                                showPopover = false
                                            })
                                            .foregroundStyle(Color(hex: "#00941D"))
                                            
                                            Button("Reject", action: {
                                                orderRequest.purchaseStatusType
                                                showPopover = false
                                            })
                                            .foregroundStyle(Color(hex: "#FF3B30"))
                                        }
                                        .frame(width: 130, height: 80)
                                        .presentationCompactAdaptation(.popover)
                                    })
                            })
                        }
                    }
                    
                    // Item count and remarks
                    Text("\(orderRequest.quantity) items")
                        .font(.customfont(.medium, fontSize: 12))
                        .foregroundColor(Color(hex: "#0A0019"))
                        .opacity(0.5)
                    
                    Text("Remarks: \(orderRequest.remark ?? "No remarks")")
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(Color(hex: "#0A0019"))
                        .opacity(0.5)
                }
            }
            .padding([.horizontal, .top])
            
            // Location and contact details
            HStack {
                Group {
                    Image(systemName: "scope")
                        .foregroundColor(.yellow)
                    Text("St 323 - Toeul kork")
                    
                    Spacer()
                        .frame(width: 22)
                    Image(systemName: "phone.fill")
                        .foregroundColor(.yellow)
                    Text("cheata, ")
                    + Text("016 860 375")
                }
                .font(.customfont(.semibold, fontSize: 14))
            }
            .padding(.horizontal, 10)
            .foregroundColor(Color(hex: "#7B7D92"))
            
            // Divider
            Divider()
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(red: 0.836, green: 0.875, blue: 0.924))
            
            // Price and payment method
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    HStack {
                        Text(LocalizedStringKey("Total"))
                        Spacer()
                        Text("$\(String(format: "%.2f", orderRequest.foodSellCardResponse.price))")
                    }
                    .foregroundStyle(Color(hex: "#0A0019"))
                    .font(.customfont(.semibold, fontSize: 14))
                    
                    HStack {
                        Text(LocalizedStringKey("Pay with \(orderRequest.paymentType)"))
                        Spacer()
                        Text("$\(String(format: "%.2f", orderRequest.foodSellCardResponse.price))")
                    }
                    .foregroundStyle(Color(hex: "#0A0019"))
                    .font(.customfont(.semibold, fontSize: 14))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.836, green: 0.875, blue: 0.924), lineWidth: 1.5)
        )
    }
    
    // MARK: - Helper Functions
    private func formatTimeAgo(from dateString: String) -> String {
        guard let date = parseDate(dateString) else {
            return "Invalid Date"
        }
        let now = Date()
        let minutesAgo = Int(now.timeIntervalSince(date) / 60)
        
        if minutesAgo < 1 {
            return "Just now"
        } else {
            return "\(minutesAgo) m ago"
        }
    }
    
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
        return nil
    }
}




