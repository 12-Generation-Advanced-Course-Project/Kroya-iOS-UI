//
//  OrdersView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 30/9/24.
//

import SwiftUI

struct OrdersView: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    @State private var isExpanded = false
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Orders Text Header
                HStack {
                    Text("Orders")
                        .font(.customfont(.bold, fontSize: 18))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 16)
                
                Spacer().frame(height: 10)
                
                // Search Bar
                NavigationLink(destination: SearchScreen()
                ) {
                    HStack {
                        Image("ico_search1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("Search item")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(.gray)
                            .frame(width: .screenWidth * 0.26)
                            .padding(.trailing, 12)
                        
                        Spacer()
                    }
                    .padding(.leading, 12)
                    .frame(width: .screenWidth * 0.93, height: .screenHeight * 0.05)
                    .background(Color(hex: "#F3F2F3"))
                    .cornerRadius(12)
                }.onAppear{
                    print("search")
                }
                
                // Tab View
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(["All", "Order", "Sale"], id: \.self) { title in
                            Text(title)
                                .onTapGesture {
                                    selectedSegment = ["All", "Order", "Sale"].firstIndex(of: title) ?? 0
                                }
                                .fontWeight(.semibold)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(selectedSegment == (["All", "Order", "Sale"].firstIndex(of: title) ?? 0) ? .black.opacity(0.8) : .black.opacity(0.5))
                                .padding(.horizontal, 19)
                        }
                        Spacer()
                    }
                    .padding(.top)
                    // Geometry Reader for Dynamic Line Under the Selected Tab
                    GeometryReader { geometry in
                        Divider()
                        Rectangle()
                            .fill(PrimaryColor.normal)
                            .frame(width: geometry.size.width / 7, height: 2)
                            .offset(x: selectedSegment == 2
                                    ? CGFloat(selectedSegment) * geometry.size.width / 4.7
                                    : CGFloat(selectedSegment) * geometry.size.width / 5)
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                    .frame(height: 2)
                    
                }
                .padding(.top, 5)
                
                // Content for Each Tab
                TabView(selection: $selectedSegment) {
                    AllTabView(iselected: selectedSegment)
                        .tag(0)
                    OrderTabview(iselected: selectedSegment)
                        .tag(1)
                    SaleTabView(iselected: selectedSegment)
                        .tag(2)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
            }
        }
    }
}

#Preview {
    OrdersView()
}


