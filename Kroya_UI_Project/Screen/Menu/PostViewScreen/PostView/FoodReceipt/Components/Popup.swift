//
//  Popup.swift
//  PopUp
//
//  Created by KAK-LY on 16/10/24.
//

import SwiftUI

struct Popup<Content: View>: View {
    
    @Binding var isPresented: Bool
    let content: Content
    let dismissOnTapOutside: Bool
    
    var body: some View {
        ZStack {
            // Fullscreen dimmed background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    if dismissOnTapOutside {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            
            VStack{
                Spacer()
                // The close button positioned outside the main content
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isPresented = false
                            }
                        }) {
                            ZStack{
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
                }
                Spacer()

                content
                Spacer()
                
            }
            .padding(.bottom, 70)
            
            
            
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
    }
}

// Usage
extension Popup {
    init(isPresented: Binding<Bool>,
         dismissOnTapOutside: Bool = true,
         @ViewBuilder _ content: () -> Content) {
        _isPresented = isPresented
        self.dismissOnTapOutside = dismissOnTapOutside
        self.content = content()
    }
}
