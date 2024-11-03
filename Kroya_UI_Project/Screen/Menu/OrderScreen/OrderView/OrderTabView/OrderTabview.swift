//
//  OrderTabview.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 5/10/24.
//
import SwiftUI

struct OrderTabView: View {
    
    var iselected: Int

    @State private var isExpandedToday = true
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                DisclosureGroup("Today", isExpanded: $isExpandedToday) {
                    VStack(spacing: 15) {
                        
                        NavigationLink(destination:
                                        FoodDetailView(
                                            theMainImage: "Songvak",
                                            subImage1: "ahmok",
                                            subImage2: "brohok",
                                            subImage3: "somlorKari",
                                            subImage4: "Songvak",
                                            showOrderButton: false,
                                            showButtonInvoic: true,
                                            invoiceAccept: true
                            
                        ))
                        {
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                        }
                        
                        NavigationLink(destination:
                                             FoodDetailView(
                                                 theMainImage: "Songvak",
                                                 subImage1: "ahmok",
                                                 subImage2: "brohok",
                                                 subImage3: "somlorKari",
                                                 subImage4: "Songvak",
                                                 showOrderButton: false,
                                                 showButtonInvoic: true,
                                                 invoiceAccept: false
                                             )){
                                   OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                               }
                    }
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                
                // Disclosure Group for Yesterday
                DisclosureGroup("Yesterday", isExpanded: $isExpandedYTD) {
                    VStack(spacing: 15) {
                        
                        NavigationLink(destination:
                               FoodDetailView(
                                    theMainImage: "Songvak",
                                    subImage1: "ahmok",
                                    subImage2: "brohok",
                                    subImage3: "SomlorKari",
                                    subImage4: "Songvak",
                                    showOrderButton: false,
                                    showButtonInvoic: true,
                                    invoiceAccept: true
                               )){
                                   OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                               }
                    }
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                
                DisclosureGroup("Last 2 days", isExpanded: $isExpandedLst2Day) {
                    VStack(spacing: 15) {
                        
                        NavigationLink(destination:
                               FoodDetailView(
                                    theMainImage: "Songvak",
                                    subImage1: "ahmok",
                                    subImage2: "brohok",
                                    subImage3: "somlorKari",
                                    subImage4: "Songvak",
                                    showOrderButton: false,
                                    showButtonInvoic: true,
                                    invoiceAccept: false
                               )){
                                   OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                               }
                    }
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            }
            .padding(.horizontal)
            
            
        }
        .background(Color.clear)
        .scrollIndicators(.hidden)
    }
}
