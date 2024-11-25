
import SwiftUI
import SDWebImageSwiftUI

struct NotificationComponent: View {
    
    var notification: NotificationModel
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    
    var body: some View {
        
        VStack {
            HStack {
                ZStack(alignment: .topLeading) {
                    // Construct the full URL for the image
                    if let url = URL(string: urlImagePrefix + notification.foodPhoto) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(12)
                    } else {
                        // Placeholder image when no URL is available
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(12)
                    }
                }
                
                // Title and description
                VStack(alignment: .leading, spacing: 5){
                    HStack{
                        Text(notification.description)
                            .font(.system(size: 14, weight: .medium))
                    }
                    // Time text
                    Text(notification.createdDate)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                // Yellow dot (status indicator)
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 10, height: 10)
                    .padding(.top, 5)
                
            }
            
        }
        
        .padding(.vertical, 10)
        Divider()
        
        
    }
}


