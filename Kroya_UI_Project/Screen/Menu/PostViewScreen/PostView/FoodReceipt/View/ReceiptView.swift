
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//


import SwiftUI
import Photos

struct ReceiptView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    @State private var presentPopup = false
    @ObservedObject var viewModel = ReceiptViewModel()
    var isOrderReceived: Bool
    var PurchaseId:Int
  

    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    // Top bar with back button and title
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }.padding(.leading,15)
                        
                        Text("Receipt")
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity,alignment: .center)
                            .padding(.trailing,35)
                    }
                    if isOrderReceived {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                            Text(LocalizedStringKey("Receive an order"))
                                .font(.system(size: 21, weight: .medium))
                        }
                    } else {
                        
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                            Text("Payment Successful")
                                .font(.system(size: 18, weight: .medium))
                                .frame(maxWidth: .infinity,alignment: .center)
                            
                        }
                    }
                    
                    ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup, isOrderReceived: isOrderReceived, FoodSellId: PurchaseId)
                    
                    // Confirm button
                    if isOrderReceived{
                        Button(action: {
                            dismiss()
                        }) {
                            Text(LocalizedStringKey("Confirm"))
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                    }}
                if presentPopup {
                    Popup(isPresented: $presentPopup, dismissOnTapOutside: true) {
                        ReceiptCardForSuccess(viewModel: viewModel, presentPopup: $presentPopup, isOrderReceived: isOrderReceived, FoodSellId: PurchaseId)
                            .transition(.scale)
                            .animation(.easeInOut(duration: 0.3))
                    }
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)

        
        
        
    }
}
