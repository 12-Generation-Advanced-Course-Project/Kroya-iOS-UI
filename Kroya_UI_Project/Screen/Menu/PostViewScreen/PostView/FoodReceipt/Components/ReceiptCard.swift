//
//  ReceiptCard.swift
//  Kroya
//
//  Created by KAK-LY on 15/10/24.
//

import SwiftUI

struct ReceiptCard: View {
    
    @ObservedObject var viewModel = ReceiptViewModel()
    @Binding var presentPopup: Bool

    var body: some View {
        VStack {
            ZStack {
                Image("receipt")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 550)
                    .padding(.horizontal)
                
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        Image("food_background")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.receipt.amount)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack {
                                Image(systemName: "arrow.up.right")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(.red)
                                
                                Text(viewModel.receipt.paidTo)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.leading, 20)
                    .offset(y: -7)
                    
                    VStack(alignment: .leading, spacing: 18) {
                        ReceiptRow(label: "Item", value: viewModel.receipt.item, valueColor: .yellow)
                        ReceiptRow(label: "Reference#", value: viewModel.receipt.referenceNumber)
                        ReceiptRow(label: "Order date", value: viewModel.receipt.orderDate)
                        ReceiptRow(label: "Paid by", value: viewModel.receipt.paidBy)
                        ReceiptRow(label: "Payer", value: viewModel.receipt.payer)
                        
                        HStack {
                            Text("Seller")
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(viewModel.receipt.sellerName)
                                    .font(.system(size: 16, weight: .medium))
                                Text(viewModel.receipt.sellerPhone)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            Spacer()
                            Image(systemName: "phone.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.yellow)
                        }
                        .padding(.horizontal)
                        Rectangle()
                            .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Button {
                            withAnimation(.linear(duration: 0.1)) {
                                presentPopup = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.yellow)
                                
                                Text("Download Receipt")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
            }
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
//                .font(.customfont(.regular, fontSize: 16))
                .frame(minWidth: 100, alignment: .leading)
            HStack{
                Text(value)
//                    .font(.customfont(.medium, fontSize: 16))
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

