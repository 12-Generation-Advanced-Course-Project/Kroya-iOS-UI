import SwiftUI

struct NotificationComponent: View {
    
    var image: String = "Songvak"
    var name: String = "StoreName"
    var notificationType: Int
    var time: String = "14 m ago"
    var seen: Bool // Add seen parameter to control the circle indicator
    
    var body: some View {
        let (status, description): (String, String)
        
        switch notificationType {
        case 1:
            status = "rejected"
            description = "Unfortunately, your order was rejected."
        case 2:
            status = "accepted order"
            description = "Please be patient and wait for the merchant to prepare your meal. patient and wait for the merchant to prepare your meal."
        case 3:
            status = "is being shipped"
            description = "Please be patient."
        case 4:
            status = "has arrived"
            description = "Your order is ready."
        default:
            status = ""
            description = ""
        }
        
        return VStack(alignment: .leading) {
            HStack(spacing: 15) {
                Image(image)
                    .resizable()
                    .frame(width: 47, height: 47)
                    .cornerRadius(12)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(name) ")
                            .font(.customfont(.medium, fontSize: 12))
                        + Text("\(status)")
                            .font(.customfont(.medium, fontSize: 12))
                        + Text(", \(description)")
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundStyle(.black.opacity(0.6))
                        Spacer()
                        if !seen {
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .frame(height: 35)
                    .lineLimit(2)
                    
                    Text(time)
                        .font(.customfont(.regular, fontSize: 10))
                        .foregroundColor(.black.opacity(0.6))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            Divider()
        }
    }
}

//#Preview {
//    NotificationComponent(notificationType: 1)
//}
