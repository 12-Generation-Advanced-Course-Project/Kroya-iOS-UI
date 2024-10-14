//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 12/10/24.
//

import SwiftUI

struct ReceiptView: View {
    // Inject the ViewModel
    @ObservedObject var viewModel = ReceiptViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Success Header Section
                VStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(red: 0.242, green: 0.741, blue: 0.307))
                    
                    Text("Success")
                        .font(.customfont(.medium, fontSize: 24))
                        .foregroundColor(.black)
                }
                .padding(.top, 30)
                
                // Receipt Card Section
                ZStack {
                    Image("receipt")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        // Payment Info
                        HStack(spacing: 15) {
                            Image("Men")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(viewModel.receipt.amount) // Use the amount from ViewModel
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(.black)
                                
                                HStack {
                                    Image(systemName: "arrow.up.right")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(.red)
                                    
                                    Text(viewModel.receipt.paidTo) // Use the paidTo from ViewModel
                                        .font(.customfont(.medium, fontSize: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.leading, 20)
                        .offset(y: -7)
                        
                        // Information Rows
                        VStack(alignment: .leading, spacing: 20) {
                            ReceiptRow(label: "Item", value: viewModel.receipt.item, valueColor: .yellow)
                            ReceiptRow(label: "Reference#", value: viewModel.receipt.referenceNumber)
                            ReceiptRow(label: "Order date", value: viewModel.receipt.orderDate)
                            ReceiptRow(label: "Paid by", value: viewModel.receipt.paidBy)
                            ReceiptRow(label: "Payer", value: viewModel.receipt.payer)
                            
                            // Seller Row with Phone Icon
                            HStack {
                                Text("Seller")
                                    .font(.customfont(.regular, fontSize: 16))
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(viewModel.receipt.sellerName)
                                        .font(.customfont(.medium, fontSize: 16))
                                    Text(viewModel.receipt.sellerPhone)
                                        .font(.customfont(.medium, fontSize: 16))
                                }
                                Spacer()
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.yellow)
                            }
                            .padding(.horizontal)
                            // Add separator
                            Rectangle()
                                .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
                                .frame(height: 1)
                        }
                        .padding(.horizontal)
                        
                        // Download Receipt Button
                        HStack {
                            Spacer()
                            Button(action: {
                                // Action for downloading receipt
                            }) {
                                HStack {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.yellow)
                                    
                                    Text("Download receipt")
                                        .font(.customfont(.medium, fontSize: 16))
                                        .foregroundColor(.yellow)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 50)
            .navigationTitle("Receipt")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ReceiptRow: View {
    var label: String
    var value: String
    var valueColor: Color = .black
    
    var body: some View {
        HStack(spacing: 20){
            Text(label)
                .font(.customfont(.regular, fontSize: 16))
                .frame(minWidth: 100, alignment: .leading)
            HStack{
                Text(value)
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(valueColor)
            }
        }
        .padding(.horizontal)
        // Add separator
        Rectangle()
            .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
            .frame(height: 1)
    }
}

#Preview {
    ReceiptView()
}
