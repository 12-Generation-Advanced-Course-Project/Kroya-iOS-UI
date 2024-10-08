//
//  AllTabView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 5/10/24.
//

import SwiftUI

struct AllTabView:View {
    var iselected:Int?
    @State private var isExpandedToday = false
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            VStack(alignment:.leading) {
                DisclosureGroup("Today", isExpanded: $isExpandedToday) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment:.leading,spacing: 15){
                            
                            OrderCard(isAccepted: true, isOrder: true)
                            OrderCard(isAccepted: false, isOrder: false)
                            OrderCard(isAccepted: true, isOrder: true)
                            OrderCard(isAccepted: false, isOrder: false)
                            Spacer().frame(height: 5)
                        }
                        .frame(height: .screenHeight * 0.5)
                        .padding(.leading,10)
                    }
                    
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(width: .screenWidth * 0.9)
                .foregroundStyle(.black)
                .accentColor(.black)
                
                DisclosureGroup("Yesterday", isExpanded: $isExpandedYTD) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15){
                            
                            OrderCard(isAccepted: true, isOrder: true)
                            OrderCard(isAccepted: false, isOrder: false)
                            OrderCard(isAccepted: true, isOrder: true)
                            OrderCard(isAccepted: false, isOrder: false)
                            Spacer().frame(height: 5)
                        }
                        .frame(height: .screenHeight * 0.5)
                        .padding(.leading,10)
                    }
                    
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(width: .screenWidth * 0.9)
                .foregroundStyle(.black)
                .accentColor(.black)
                DisclosureGroup("Last 2 Days", isExpanded: $isExpandedLst2Day) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15){
                            
                            OrderCard(isAccepted: true, isOrder: true)
                            OrderCard(isAccepted: false, isOrder: false)
                            OrderCard(isAccepted: true, isOrder: true)
                            OrderCard(isAccepted: false, isOrder: false)
                            Spacer().frame(height: 5)
                        }
                        .frame(height: .screenHeight * 0.5)
                        .padding(.leading,10)
                    }
                    
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(width: .screenWidth * 0.9)
                .foregroundStyle(.black)
                .accentColor(.black)
                .padding(.bottom,10)
                Spacer()
            }
        }
       
    }
}

#Preview {
    AllTabView()
}
