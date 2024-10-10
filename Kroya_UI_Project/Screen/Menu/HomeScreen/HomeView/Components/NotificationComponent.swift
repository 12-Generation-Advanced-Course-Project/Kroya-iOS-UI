//
//  AcceptedOrder.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 9/10/24.
//

import SwiftUI

struct NotificationComponent: View {
    
    var image: String = "Songvak"
    var name: String = "StoreName"
    var status: String
    var description: String = ""
    var time: String = "14 m ago"
    init(notificationType: Int){
        switch notificationType{
        case 1 :
            self.status = "accepted order "
            self.description = "please be patient and wait for merchant to prepare meal."
        case 2 :
            self.status = "has arrived "
            self.description = "Your order "
        case 3 :
            self.status = "is being shipped "
            self.description = "please be patient."
        case 4 :
            self.status = "rejected "
            self.description = "please be patient."
        default:
            self.status = ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("\(image)")
                    .resizable()
                   
                    .frame(width: 50,height: 50)
                    .cornerRadius(17)
                
                VStack(alignment: .leading, spacing: 10){
                    HStack {
                        Text("\(name) ")
                            .font(.customfont(.medium, fontSize: 12))
                        + Text("\(status)")
                            .font(.customfont(.medium, fontSize: 12))
                        + Text(", \(description)")
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundStyle(.black.opacity(0.6))
                    }
                    .lineLimit(2)
                    
                    Text("\(time)")
                        .font(.customfont(.regular, fontSize: 10))
                        .foregroundStyle(.black .opacity(0.6))
                }
                .layoutPriority(1)
            }
        }
        
    }
}
#Preview {
    NotificationComponent(notificationType: 2)
}
