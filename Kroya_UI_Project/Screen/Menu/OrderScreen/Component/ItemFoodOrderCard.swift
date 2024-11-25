import SwiftUI
import SDWebImageSwiftUI

struct ItemFoodOrderCard: View {
    
    @Binding var orderRequest: OrderRequestModel
    @StateObject private var OrderViewmodel = OrderViewModel()
    var showEllipsis: Bool = true
    @State private var showPopover = false
    @Binding var show3dot: Bool
    let Keyaccept = "Accept"
    let Keyreject = "Reject"
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    @State private var purchaseStatus: String = "Pending" // Default status
    @State private var statusColor: Color = .gray // Default color
    
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10) {
            HStack(spacing: 5) {
                
                // Construct the full URL for the image
                if let photoFilename = orderRequest.foodSellCardResponse.photo.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
                    WebImage(url: url)
                        .resizable()
                        .frame(width: 65, height: 65)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } else {
                    // Placeholder image when no URL is available
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 65, height: 65)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    ZStack{
                        HStack {
                            // Food name
                            Text(orderRequest.foodSellCardResponse.name)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .frame(maxWidth: .infinity)
                            // Dynamic Status
                            Text(orderRequest.purchaseStatusType!)
                                .font(.customfont(.semibold, fontSize: 8))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                                .foregroundColor(getStatusColor(status: orderRequest.purchaseStatusType!))
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(getStatusColor(status: orderRequest.purchaseStatusType!).opacity(0.2))
                                )
                                .offset(y:-10)
                            Spacer()
                            if let timeAgo = orderRequest.purchaseDate {
                                Text(formatTimeAgo(from: timeAgo))
                                    .font(.customfont(.semibold, fontSize: 12))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity,alignment: .trailing)
                                    .hidden()
                                
                            }
                         
                            // Time
                        }.frame(maxWidth:.infinity,alignment: .leading)
                     
                        HStack{
                            if let timeAgo = orderRequest.purchaseDate {
                                Text(formatTimeAgo(from: timeAgo))
                                    .font(.customfont(.semibold, fontSize: 12))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity,alignment: .trailing)
                                
                            }
                            if showEllipsis {
                                Button(action: {
                                    showPopover = true
                                }, label: {
                                    Image(systemName: "ellipsis")
                                        .rotationEffect(.degrees(90)) // Rotate to make it vertical
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        .popover(isPresented: $showPopover, attachmentAnchor: .point(.topLeading), content: {
                                            VStack(spacing: 8) {
                                                Button("Accept", action: {
                                                    orderRequest.purchaseStatusType = "ACCEPTED" // Update the status
                                                    showPopover = false
                                                    OrderViewmodel.updatePurchaseStatus(purchaseId: orderRequest.id, newStatus: "ACCEPTED")
                                                    print("purcahaseId \(orderRequest.id)")
                                                })
                                                .foregroundStyle(Color(hex: "#00941D"))
                                                
                                                Button("Reject", action: {
                                                    orderRequest.purchaseStatusType = "REJECTED" // Update the status
                                                    showPopover = false
                                                    OrderViewmodel.updatePurchaseStatus(purchaseId: orderRequest.id, newStatus: "REJECTED")
                                                    print("purcahaseId \(orderRequest.id)")
                                                })
                                                .foregroundStyle(Color(hex: "#FF3B30"))
                                                
                                                Button("Pending", action: {
                                                    orderRequest.purchaseStatusType = "PENDING" // Update the status
                                                    showPopover = false
                                                    OrderViewmodel.updatePurchaseStatus(purchaseId: orderRequest.id, newStatus: "PENDING")
                                                    print("purcahaseId \(orderRequest.id)")
                                                })
                                                .foregroundStyle(Color.orange)
                                            }
                                            .frame(width: 130, height: 100)
                                            .presentationCompactAdaptation(.popover)
                                        })
                                })
                            }
                        }
                        .offset(x: 10, y:-10)
                    }
                    // Item count and remarks
                    Text("\(orderRequest.quantity) items")
                        .font(.customfont(.medium, fontSize: 12))
                        .foregroundColor(Color(hex: "#0A0019"))
                        .opacity(0.5)
                    
                    Text("Remarks: \(orderRequest.remark!)")
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(Color(hex: "#0A0019"))
                        .opacity(0.5)
                }
            }
            .padding([.horizontal, .top])
            
            
            // Location and contact details
            HStack {
                Group {
                    Image(systemName: "scope")
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundColor(.yellow)
                    Text(orderRequest.buyerInformation.location)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "phone.fill")
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundColor(.yellow)
                    HStack{
                        Text("\(orderRequest.buyerInformation.fullName),")
                        Text(orderRequest.buyerInformation.phoneNumber)
                    }
                    .lineLimit(1)
                }
                .font(.customfont(.semibold, fontSize: 12))
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
                        //                        Text("$\(String(format: "%.2f", orderRequest.totalPrice))")
                        Text("៛\(String(format: "%.2f", Double(orderRequest.totalPrice)))")
                    }
                    .foregroundStyle(Color(hex: "#0A0019"))
                    .font(.customfont(.semibold, fontSize: 14))
                    
                    HStack {
                        Text(LocalizedStringKey("Pay with \(orderRequest.paymentType)"))
                        Spacer()
                        //                        Text("$\(String(format: "%.2f", orderRequest.totalPrice))")
                        Text("៛\(String(format: "%.2f", Double(orderRequest.totalPrice)))")
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
        let timeInterval = now.timeIntervalSince(date)
        
        let minutesAgo = Int(timeInterval / 60) // Convert seconds to minutes
        let hoursAgo = Int(timeInterval / 3600) // Convert seconds to hours

        if minutesAgo < 1 {
            return "Just now"
        } else if minutesAgo < 60 {
            return "\(minutesAgo) m ago"
        } else if hoursAgo < 24 {
            return "\(hoursAgo) h ago"
        } else {
            let daysAgo = Int(timeInterval / (3600 * 24)) // Convert seconds to days
            return "\(daysAgo) d ago"
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
    private func getStatusColor(status: String) -> Color {
        switch status.uppercased() {
        case "ACCEPTED":
            return Color(hex: "#00941D") // Green
        case "REJECTED":
            return Color(hex: "#FF3B30") // Red
        case "PENDING":
            return Color.orange // Orange
        default:
            return Color.gray // Default color for unknown statuses
        }
    }


}
