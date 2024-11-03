
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//


import SwiftUI
import Photos

struct ReceiptView: View {
    @Environment(\.dismiss) private var dismiss // This will dismiss only the ReceiptView
    @Binding var isPresented: Bool
    @State private var presentPopup = false  // State to control popup visibility    @ObservedObject var viewModel   = ReceiptViewModel()
    @ObservedObject var viewModel   = ReceiptViewModel()

    var body: some View {
        
        ZStack{
            VStack {
                // Orders Text Header
                HStack {
                    Button(action: {
                      dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text(LocalizedStringKey("Receipt"))
                        .font(.customfont(.bold, fontSize: 18))
                  
                    Spacer()
                   
                }.padding(.horizontal, 15)
                    //.padding(.bottom, 10)
                Spacer()
                Success()
                // Pass parameters in the correct order
                ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup )
            }
            .padding(.bottom, 50)
           // .navigationTitle("Receipt")
           // .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)  // Hide back button
            
            // Show popup if presentPopup is true
            if presentPopup {
                Popup(isPresented: $isPresented , dismissOnTapOutside: true) {
                    ReceiptCard1(viewModel: viewModel, presentPopup: $presentPopup)
                        .transition(.scale)  // Add a scale transition
                        .animation(.easeInOut(duration: 0.3))  // Apply the animation to the transition
             
                    
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
