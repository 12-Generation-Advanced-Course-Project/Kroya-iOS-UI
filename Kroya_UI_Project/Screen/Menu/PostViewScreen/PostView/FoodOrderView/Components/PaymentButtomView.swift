//
//  PaymentButtomView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 10/10/24.
//

import SwiftUI

struct PaymentButtomView: View {
    
    var body: some View {
        
//        VStack {
            
            HStack(spacing: 16) {
                
                Button(action: {
                    // Action for cash payment
                }) {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.black)
                        Text("Pay with cash")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.995, green: 0.969, blue: 0.852))
                    .cornerRadius(10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.962, green: 0.941, blue: 0.854), lineWidth: 1)
                )
                
                
                Button(action: {
                    // Action for KHQR payment
                }) {
                    VStack(alignment: .leading, spacing: 10) {
                        Image("khqr")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Pay with KHQR")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.836, green: 0.875, blue: 0.924), lineWidth: 1)
                )
            }
//            .padding()
//        }
    }
}

#Preview {
    PaymentButtomView()
}
