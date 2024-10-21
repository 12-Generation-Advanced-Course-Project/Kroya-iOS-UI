import SwiftUI

// Data model for food items
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let itemsCount: Int
    let remarks: String
    let price: Double
    let paymentMethod: String
    var status: String? // For optional status like "Accept" or "Reject"
    let timeAgo: String? // Optional timeAgo to display time like "15m ago"
}

// View for displaying a food item card with optional timeAgo and status
struct ItemFoodOrderCard: View {
    let item: FoodItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Top HStack containing image, title, and other info
            HStack(spacing: 12) {
                // Food image
                Image("brohok")
                    .resizable()
                    .frame(width: 65, height: 65)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        // Food name
                        Text(item.name)
                            .font(.customfont(.semibold, fontSize: 17))
                        
                        
                        // Status tag (e.g., "Accept" or "Reject"), shown only if provided
                        if let status = item.status {
                            Text(status)
                                .font(.customfont(.semibold, fontSize: 12))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(RoundedRectangle(cornerRadius: 5).fill(status == "Accept" ? Color.green.opacity(0.2) : Color.red.opacity(0.2)))
                                .foregroundColor(status == "Accept" ? .green : .red)
                        }
                        Spacer()
                        // Time ago (e.g., "15m ago"), shown only if provided
                        if let timeAgo = item.timeAgo {
                            Text(timeAgo)
                                .font(.customfont(.medium, fontSize: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Item count
                    Text("\(item.itemsCount) items")
                        .font(.customfont(.medium, fontSize: 12))
                        .foregroundColor(Color(hex: "#0A0019"))
                        .opacity(0.5)
                    
                    // Remarks
                    Text("Remarks: \(item.remarks)")
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
                    Spacer().frame(width: 22)
                    Image(systemName: "phone.fill")
                        .foregroundColor(.yellow)
                    Text("016 860 375")
                }
                .font(.customfont(.semibold, fontSize: 16))
            }
            .padding(.horizontal)
            .foregroundColor(Color(hex: "#7B7D92"))
            
            // Divider
            Divider().frame(maxWidth: .infinity).foregroundColor(Color(red: 0.836, green: 0.875, blue: 0.924))
            
            // Price and payment method
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    HStack {
                        Text("Total")
                        Spacer()
                        Text("$\(String(format: "%.2f", item.price))")
                    }
                    .foregroundStyle(Color(hex: "#0A0019"))
                    .font(.customfont(.semibold, fontSize: 14))
                
                    
                    HStack {
                        Text("Pay with \(item.paymentMethod)")
                        Spacer()
                        Text("$\(String(format: "%.2f", item.price))")
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
}


#Preview {
    ItemFoodOrderCard(item:  FoodItem(name: "Brohok", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: nil, timeAgo: nil))
    ItemFoodOrderCard(item:FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: "Accept", timeAgo: "35m ago"))
}

