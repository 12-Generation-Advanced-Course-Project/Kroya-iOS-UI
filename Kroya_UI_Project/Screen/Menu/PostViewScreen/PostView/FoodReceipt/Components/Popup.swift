//
//  Popup.swift
//  PopUp
//
//  Created by KAK-LY on 17/10/24.
//

import SwiftUI

struct Popup<Content: View>: View {
    @ObservedObject var navigationManager: NavigationManager

    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss // Environment dismiss for navigation stack
    let content: Content
    let dismissOnTapOutside: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    if dismissOnTapOutside {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isPresented = false // Dismiss the popup
                            dismiss() // Dismiss ReceiptView and go back to FoodCheckOutView
                            navigationManager.navigateBack(to: .first)
                        }
                    
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 26, height: 26)
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color.black)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                content

                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
    }
}

extension Popup {
    init(isPresented: Binding<Bool>,
         dismissOnTapOutside: Bool = true,
         @ViewBuilder _ content: () -> Content) {
        _isPresented = isPresented
        self.dismissOnTapOutside = dismissOnTapOutside
        self.content = content()
        self.navigationManager = NavigationManager()
        
    }
}
