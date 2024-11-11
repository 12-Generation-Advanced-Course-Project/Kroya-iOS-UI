
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
    @ObservedObject var viewModel   = ReceiptViewModel()
    var isOrderReceived: Bool 
    //@State private var isOrderReceived = true

    
    var body: some View {
        
        ZStack{
            VStack {
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
                        Text("Success") // Default text
                            .font(.system(size: 21, weight: .medium))
                  
                    }
                }
          
                ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup, isOrderReceived: isOrderReceived)
                
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
          //  .padding(.bottom, 50)
            .navigationTitle("Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)  // Hide back button
            .toolbar {
                           ToolbarItem(placement: .navigationBarLeading) {
                               if !presentPopup {
                                   Button(action: {
                                       dismiss()
                                   }) {
                                       Image(systemName: "arrow.left")
                                           .resizable()
                                           .scaledToFit()
                                           .frame(width: 20, height: 20)
                                           .foregroundColor(.black)
                                   }
                               }
                           }
                       }
            if presentPopup {
                Popup(isPresented: $presentPopup, dismissOnTapOutside: true) {
                    ReceiptCard1(viewModel: viewModel, presentPopup: $presentPopup, isOrderReceived: isOrderReceived)
                        .transition(.scale)  // Add a scale transition
                        .animation(.easeInOut(duration: 0.3))
                }
            }

        }
        
    }
}

#Preview {
    NavigationView {
//        ReceiptView()
    }
}
