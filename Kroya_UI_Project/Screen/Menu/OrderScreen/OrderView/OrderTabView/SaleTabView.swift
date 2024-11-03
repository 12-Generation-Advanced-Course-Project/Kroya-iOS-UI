//
//  SaleTabView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 5/10/24.
//

import SwiftUI

struct SaleTabView: View {
    
    var iselected: Int

    @State private var isExpandedToday = true
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                DisclosureGroup("Today", isExpanded: $isExpandedToday) {
                    VStack(spacing: 15) {
                        OrderCard(isAccepted: true, isOrder: false, showIcon: true)
                    }
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                
                // Disclosure Group for Yesterday
                DisclosureGroup("Yesterday", isExpanded: $isExpandedYTD) {
                    VStack(spacing: 15) {
                        OrderCard(isAccepted: false, isOrder: false, showIcon: true)
                    }
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                
                DisclosureGroup("Last 2 days", isExpanded: $isExpandedLst2Day) {
                    VStack(spacing: 15) {
                        OrderCard(isAccepted: true, isOrder: false, showIcon: true)
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
