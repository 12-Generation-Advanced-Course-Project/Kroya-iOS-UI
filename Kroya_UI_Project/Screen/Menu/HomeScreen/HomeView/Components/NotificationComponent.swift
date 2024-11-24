//import SwiftUI
//import SDWebImageSwiftUI
//
//// Define the Notification model
////struct NotificationModel: Identifiable, Hashable {
////    let id: UUID
////    let title: String
////    var isClicked: Bool
////}
//
//// NotificationComponent to display individual notifications
//struct NotificationComponent: View {
//    
//    var notification: NotificationModel
//    //    var image: String = "Songvak" // Example image
//    //    var name: String = "StoreName"
//    //    var notificationType: Int
//    //    var time: String = "14 m ago"
//    var seen: Bool // Add seen parameter to control the circle indicator
//    // @Binding var isClicked: Bool
//    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
//    
//    //
//    var body: some View {
//        //        let (status, description): (String, String)
//        //
//        //        switch notificationType {
//        //        case 1:
//        //            status = "rejected"
//        //            description = "Unfortunately, your order was rejected."
//        //        case 2:
//        //            status = "accepted order"
//        //            description = "Please be patient and wait for the merchant to prepare your meal. patient and wait for the merchant to prepare your meal."
//        //        case 2:
//        //            status = "has arrived"
//        //            description = "Your order is ready."
//        //        case 3:
//        //            status = "is being shipped"
//        //            description = "Please be patient."
//        //        case 4:
//        //            status = "has arrived"
//        //            description = "Your order is ready."
//        //        default:
//        //            status = ""
//        //            description = ""
//        //        }
//        
////        /*VStack(alignment: .leading)*/ {
//        VStack{
//            HStack(spacing: 15) {
//                ZStack(alignment: .topLeading) {
//                    // Construct the full URL for the image
//                    if let photoFilename = notification.foodPhoto.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
//                        WebImage(url: url)
//                            .resizable()
//                            .frame(width: 47, height: 47)
//                            .cornerRadius(12)
//                    } else {
//                        // Placeholder image when no URL is available
//                        Image(systemName: "photo")
//                            .resizable()
//                            .frame(width: 47, height: 47)
//                            .cornerRadius(12)
//                    }
//                    VStack(alignment: .leading, spacing: 4) {
//                        HStack {
//                            Text("\(notification.description) ")
//                                .font(.custom("HelveticaNeue-Medium", size: 12)) +
//                            Text("\(notification.foodCardType)")
//                                .font(.custom("HelveticaNeue-Medium", size: 12)) +
//                            //                        Text(", \(description)")
//                            //                            .font(.custom("HelveticaNeue-Medium", size: 12))
//                            //                            .foregroundStyle(.black.opacity(0.6))
//                            //                        Spacer()
//                            //                        if !seen {
//                            //                            Circle()
//                            //                                .fill(Color.yellow)
//                            //                                .frame(width: 10, height: 10)
//                            //                        }
//                            //                    }
//                            //                    .frame(height: 35)
//                            //                    .lineLimit(2)
//                            
//                            Text(notification.createdDate)
//                                .font(.custom("HelveticaNeue-Regular", size: 10))
//                                .foregroundColor(.black.opacity(0.6))
//                        }
//                        //                if !isClicked {
//                        //                    Circle()
//                        //                        .fill(Color.yellow)
//                        //                        .frame(width: 10, height: 10)
//                        //                }
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 5)
//                    
//                    Divider()
//                }
//                .padding(.horizontal)
//                //        .onTapGesture {
//                //            if !isClicked {
//                //                isClicked = true // Set clicked state to true on first tap
//                //                // Additional action can be triggered here if needed
//                //            }        }
//            }
//        }
//    }
//}





import SwiftUI
import SDWebImageSwiftUI

struct NotificationComponent: View {
    
    var notification: NotificationModel
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    
    
    var body: some View {
        
        VStack{
            HStack(spacing: 15) {
                ZStack(alignment: .topLeading) {
                    // Construct the full URL for the image
                    if let photoFilename = notification.foodPhoto.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
                        WebImage(url: url)
                            .resizable()
                            .frame(width: 47, height: 47)
                            .cornerRadius(12)
                    } else {
                        // Placeholder image when no URL is available
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 47, height: 47)
                            .cornerRadius(12)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(notification.description) ")
                                .font(.custom("HelveticaNeue-Medium", size: 12)) +
                            Text("\(notification.foodCardType)")
                                .font(.custom("HelveticaNeue-Medium", size: 12)) +
                            Text(notification.createdDate)
                                .font(.custom("HelveticaNeue-Regular", size: 10))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
