//
//  OrderCardFood.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 3/10/24.
//

import SwiftUI

struct OrderCard: View {
    var isAccepted: Bool
    var isOrder: Bool

    var body: some View {
        HStack {
            // Image on the left
            Image("Songvak")
                .resizable()
                .frame(width: 75, height: 75)
                .cornerRadius(8)
                .padding(10)
            
            VStack(alignment: .leading, spacing: 5) {
                // Title and subtitle
                Text("Somlor Kari")
                    .font(.customfont(.medium, fontSize: 15)) // Custom font "Inter"
                    .fontWeight(.medium)
                
                Text("you are selling now")
                    .font(.customfont(.regular, fontSize: 12)) // Custom font "Inter"
                    .foregroundColor(.gray)
                
                // Price and Order/Sale Button
                HStack(spacing: 15) {
                    Text("$3.05")
                        .font(.customfont(.medium, fontSize: 15)) // Custom font "Inter"
                        .fontWeight(.medium)
                    
                    // Order/Sale Button based on isOrder boolean
                    Text(isOrder ? "Order" : "Sale")
                        .font(.customfont(.medium, fontSize: 15)) // Custom font "Inter"
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isOrder ? PrimaryColor.normal.opacity(0.2) : Color(hex: "#DDF6C3"))
                        )
                        .foregroundColor(isOrder ? .yellow : .green)
                }
                .padding(.top, 10)
            }
            
            Spacer()
            
            // Conditional display for Accept/Reject
            Text(isAccepted ? "Accept" : "Reject")
                .font(.customfont(.medium, fontSize: 12)) // Custom font "Inter"
                .foregroundColor(isAccepted ? .green : .red)
                .fontWeight(.medium)
                .offset(x: -13, y: -30)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)

        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .frame(width: .screenWidth * 0.85, height: .screenHeight * 0.1)
    }
}

#Preview {
    // Preview with "Order" and "Accept"
    OrderCard(isAccepted: true, isOrder: true)
        .padding()
    
//    // Preview with "Sale" and "Reject"
//    OrderCard(isAccepted: false, isOrder: false)
}
