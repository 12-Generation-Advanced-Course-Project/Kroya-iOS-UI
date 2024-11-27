//
//  OrderListView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/19/24.
//

import SwiftUI

struct OrderListView: View {
    
    var sellerId:Int
    var orderCountText: String?
    @State private var show3dot:Bool = true
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Spacer().frame(height: 10)
            NewItemFoodOrderCardView(show3dot: $show3dot, showEllipsis: true, sellerId: sellerId)
            
        }
        .navigationTitle(LocalizedStringKey("Orders request"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
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
                                Text(orderCountText ?? "0")
                                    .customFontSemiBoldLocalize(size: 10)
                                    .foregroundColor(.white)
                                    .padding([.bottom, .leading], 12)
                            )
                    )
            }
            
        }
    }
}







