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
                        VStack{
                            
                            OrderCard(isAccepted: true, isOrder: false, showIcon: true)
                            OrderCard(isAccepted: false, isOrder: false, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: false, showIcon: false)
                            Spacer().frame(height: 5)
                        }
                        .frame(maxWidth: .infinity,minHeight: .screenHeight * 0.48,alignment: .leading)
                     .padding(.horizontal,5)
                     
                    }
                    
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .accentColor(.black)
                .padding(.horizontal)
                
                DisclosureGroup("Yesterday", isExpanded: $isExpandedYTD) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{
                            
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: false, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: false, showIcon: false)
                            Spacer().frame(height: 5)
                        }
                        .frame(maxWidth: .infinity,minHeight: .screenHeight * 0.5,alignment: .leading)
                        .padding(.horizontal,5)
                     
                    }
                    
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .accentColor(.black)
                .padding(.horizontal)
                DisclosureGroup("Last 2 Days", isExpanded: $isExpandedLst2Day) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{
                            
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: false, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: false, showIcon: false)
                            Spacer().frame(height: 5)
                        }
                        .frame(maxWidth: .infinity,minHeight: .screenHeight * 0.5,alignment: .leading)
                        .padding(.horizontal,5)
                     
                    }
                    
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .accentColor(.black)
                .padding(.horizontal)
                Spacer()
            }
        }
       
    }
}
//
#Preview {
    AllTabView()
}
