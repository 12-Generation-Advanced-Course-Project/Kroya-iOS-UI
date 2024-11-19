//
//  PaymentButtonView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

struct PaymentButtonView: View {
    @State private var isShowingQRModal = false
    @State private var selectedPaymentMethod: String? = nil
    @Binding var payment: String
    
    var body: some View {
        HStack(spacing: 10) {
            // Pay with cash button
            Button(action: {
                selectedPaymentMethod = "CASH"
                payment = "CASH"
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack{
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.black)
                        Spacer()
                        // Show checkmark if the selected method is "CASH"
                        if selectedPaymentMethod == "CASH" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .frame(width: 20, height: 20)
                        }
                    }
                    Text(LocalizedStringKey("Pay with cash"))
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(Color.black)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.995, green: 0.969, blue: 0.852))
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.962, green: 0.941, blue: 0.854), lineWidth: 1)
            )
            
            // Pay with KHQR button
            Button(action: {
                selectedPaymentMethod = "KHQR"
                payment = "KHQR"
                isShowingQRModal = true
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image("khqr")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Image("webill365_logo_full 1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 15)
                        Spacer()
                        // Show checkmark if the selected method is "KHQR"
                        if selectedPaymentMethod == "KHQR" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .frame(width: 20, height: 20)
                        }
                    }
                    Text(LocalizedStringKey("Pay with KHQR"))
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
