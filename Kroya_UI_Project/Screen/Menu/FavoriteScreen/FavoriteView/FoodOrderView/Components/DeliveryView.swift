//
//  DeliveryView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 10/10/24.
//

import SwiftUI

struct DeliveryView: View {
    
    @State var remark: String
    var deliveryAddress: String
    var contactName: String
    var contactPhone: String
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("Delivery to")
                    .font(.customfont(.bold, fontSize: 16))
                Spacer()
                
                Button(action: {
                    // Action for KHQR payment
                }) {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .frame(width: 24, height: 24)
                        
                    }
                }
            }
            
            HStack (spacing: 10){
                
                Image(systemName: "mappin.and.ellipse")
                VStack(alignment: .leading, spacing: 5) {
                    Text(deliveryAddress)
                        .font(.customfont(.medium, fontSize: 16))
                    
                    Text(contactName)
                        .font(.customfont(.medium, fontSize: 10))
                        .foregroundColor(Color.gray)
                }
                Spacer()
            }
 
            HStack (spacing: 10){
                
                Image(systemName: "phone.fill")
                VStack(alignment: .leading, spacing: 5) {
                    Text(contactPhone)
                        .font(.customfont(.medium, fontSize: 16))
                    
                }
                Spacer()
            }
            
            
            Divider()
    
            
            HStack {
                Text("Remarks")
                    .font(.customfont(.medium, fontSize: 16))
                
                Spacer()
                
                Text("\(remark)")
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(Color.gray)
                Spacer()
            }
            .padding(5)
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.836, green: 0.875, blue: 0.924), lineWidth: 1.5)
        )
//        .padding()
    }
}

#Preview {
    DeliveryView(
        remark: "Note (optional)",
        deliveryAddress: "HRD Center",
        contactName: "St 323 - Toul Kork",
        contactPhone: "Cheata, +85593333939"
    )
}
