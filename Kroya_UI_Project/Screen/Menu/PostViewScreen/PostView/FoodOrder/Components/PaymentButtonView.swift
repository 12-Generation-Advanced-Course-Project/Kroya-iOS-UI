//
//  PaymentButtonView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

struct PaymentButtomView: View {
    @State private var isShowingQRModal = false  // State to control modal presentation

    var body: some View {
        HStack(spacing: 10) {
            // Pay with cash button
            Button(action: {
                // Action for cash payment
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
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
            .buttonStyle(PlainButtonStyle()) // Remove default button style
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.962, green: 0.941, blue: 0.854), lineWidth: 1)
            )
            
            // Pay with KHQR button
            Button(action: {
                isShowingQRModal = true  // Trigger the modal sheet
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack{
                        Image("khqr")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Image("webill365_logo_full 1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70,height: 15)
                    }
                    Text("Pay with KHQR")
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(Color.black)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle()) // Remove default button style
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.836, green: 0.875, blue: 0.924), lineWidth: 1)
            )
            .sheet(isPresented: $isShowingQRModal) {
                PaywithKHQRModalView()
                    .presentationDetents([.fraction(0.70)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
