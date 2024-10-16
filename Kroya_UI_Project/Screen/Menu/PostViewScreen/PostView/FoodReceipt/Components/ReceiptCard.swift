//
//  ReceiptCard.swift
//  Kroya
//
//  Created by KAK-LY on 15/10/24.
//

import SwiftUI

struct ReceiptCard: View {
    
    // Inject the ViewModel
    @ObservedObject var viewModel = ReceiptViewModel()
    @State var dialogShow = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Receipt Card Section
                ZStack{
                    Image("receipt")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 550)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        // Payment Info
                        HStack(spacing: 15) {
                            Image("food_background")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(viewModel.receipt.amount) // Use the amount from ViewModel
                                //                                    .font(.customfont(.medium, fontSize: 16))
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                HStack {
                                    Image(systemName: "arrow.up.right")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(.red)
                                    
                                    Text(viewModel.receipt.paidTo) // Use the paidTo from ViewModel
                                    //                                        .font(.customfont(.medium, fontSize: 14))
                                        .font(.system(size: 14, weight: .medium))
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
                                //                                    .font(.customfont(.regular, fontSize: 16))
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(viewModel.receipt.sellerName)
                                    //                                        .font(.customfont(.medium, fontSize: 16))
                                        .font(.system(size: 16, weight: .medium))
                                    Text(viewModel.receipt.sellerPhone)
                                    //                                        .font(.customfont(.medium, fontSize: 16))
                                        .font(.system(size: 16, weight: .medium))
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
                            
                            Button{
                                dialogShow.toggle()
                            }label: {
                                HStack {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.yellow)
                                    
                                    Text("Download Success")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.yellow)
                                }
                            }
                            .sheet(isPresented: $dialogShow) {
                                print("Sheet dismissed!")
                                
                            } content: {
                                
                                ZStack{
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(Color.black)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding([.top, .trailing], 20)
                                
                                ReceiptCard()
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
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
    ReceiptCard()
}
