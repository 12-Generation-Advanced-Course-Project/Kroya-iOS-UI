//
//  OrderListView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/19/24.
//

import SwiftUI

struct OrderListView: View {
    
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Spacer().frame(height: 10)
            
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
                Text("Orders request")
                    .font(.customfont(.bold, fontSize: 18))
                Spacer()
                
                Button(action : {
                    
                })
                {
                    Image("ico_note")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28)
                        .overlay(
                            Circle()
                                .fill(Color.red)
                                .scaledToFit()
                                .frame(width: 16)
                                .padding([.bottom, .leading], 12)
                                .overlay(
                                    Text("8")
                                        .font(.customfont(.semibold, fontSize: 10))
                                        .foregroundColor(.white)
                                        .padding([.bottom, .leading], 12)
                                )
                        )
                    
                    
                }
                
            }.padding(.horizontal,15)
            NewItemFoodOrderCardView(showEllipsis: true)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OrderListView()
}
