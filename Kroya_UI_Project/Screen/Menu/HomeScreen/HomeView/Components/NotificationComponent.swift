//import SwiftUI
//
//struct NotificationComponent: View {
//
//    var image: String = "Songvak"
//    var name: String = "StoreName"
//    var notificationType: Int
//    var time: String = "14 m ago"
//
//    var body: some View {
//        let (status, description): (String, String)
//
//        switch notificationType {
//        case 1:
//            status = "accepted order"
//            description = "Please be patient and wait for the merchant to prepare your meal. patient and wait for the merchant to prepare your meal."
//        case 2:
//            status = "has arrived"
//            description = "Your order is ready."
//        case 3:
//            status = "is being shipped"
//            description = "Please be patient."
//        case 4:
//            status = "rejected"
//            description = "Unfortunately, your order was rejected."
//        default:
//            status = ""
//            description = ""
//        }
//
//        return VStack(alignment: .leading) {
//            HStack(spacing: 15) {
//                Image(image)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .cornerRadius(8)
//                VStack(alignment: .leading, spacing: 4) {
//                    HStack {
//                        Text("\(name) ")
//                            .font(.customfont(.medium, fontSize: 12))
//                        + Text("\(status)")
//                            .font(.customfont(.medium, fontSize: 12))
//                        + Text(", \(description)")
//                            .font(.customfont(.medium, fontSize: 12))
//                            .foregroundStyle(.black.opacity(0.6))
//                    }
//                    .frame(height: 30)
//                    .lineLimit(2)
//
//                    Text(time)
//                        .font(.customfont(.regular, fontSize: 10))
//                        .foregroundColor(.black.opacity(0.6))
//                }
//                Circle()
//                    .fill(Color.yellow)
//                    .frame(width: 10,height: 10)
//            }
//            .padding(.vertical, 5)
//            Divider()
//        }
//        .padding(.horizontal)
//    }
//}
//
//#Preview {
//    NotificationComponent(notificationType: 1)
//}


import SwiftUI

// Define the Notification model
//struct NotificationModel: Identifiable, Hashable {
//    let id: UUID
//    let title: String
//    var isClicked: Bool
//}

// NotificationComponent to display individual notifications
struct NotificationComponent: View {
    var image: String = "Songvak" // Example image
    var name: String = "StoreName"
    var notificationType: Int
    var time: String = "14 m ago"
    var seen: Bool // Add seen parameter to control the circle indicator
   // @Binding var isClicked: Bool
    
    var body: some View {
        let (status, description): (String, String)
        
        switch notificationType {
        case 1:
            status = "rejected"
            description = "Unfortunately, your order was rejected."
        case 2:
            status = "accepted order"
            description = "Please be patient and wait for the merchant to prepare your meal. patient and wait for the merchant to prepare your meal."
        case 2:
            status = "has arrived"
            description = "Your order is ready."
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
                            .font(.custom("HelveticaNeue-Medium", size: 12)) +
                        Text("\(status)")
                            .font(.custom("HelveticaNeue-Medium", size: 12)) +
                        Text(", \(description)")
                            .font(.custom("HelveticaNeue-Medium", size: 12))
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
                        .font(.custom("HelveticaNeue-Regular", size: 10))
                        .foregroundColor(.black.opacity(0.6))
                }
//                if !isClicked {
//                    Circle()
//                        .fill(Color.yellow)
//                        .frame(width: 10, height: 10)
//                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Divider()
        }
        .padding(.horizontal)
//        .onTapGesture {
//            if !isClicked {
//                isClicked = true // Set clicked state to true on first tap
//                // Additional action can be triggered here if needed
//            }        }
    }
}


