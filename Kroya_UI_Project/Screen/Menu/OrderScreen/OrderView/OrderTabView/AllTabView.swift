//import SwiftUI
//
//struct AllTabView: View {
//    
//    var iselected: Int?
//    
//    @State private var isExpandedToday = true
//    @State private var isExpandedYTD = false
//    @State private var isExpandedLst2Day = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading) {
//                // Disclosure Group for Today
//                DisclosureGroup("Today", isExpanded: $isExpandedToday) {
//                    VStack {
//                        List {
//                            OrderCard(isAccepted: true, isOrder: false, showIcon: true)
//                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
//                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
//                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
//                        }
//                        .listStyle(PlainListStyle())
//                        .listRowSeparator(.hidden)
//                        .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.3, alignment: .leading)
//                        .scrollIndicators(.hidden)
//                    }
//                }
//                .font(.customfont(.semibold, fontSize: 16))
//                .frame(maxWidth: .infinity)
//                .foregroundStyle(.black)
//                .accentColor(.black)
//                
//                // Disclosure Group for Yesterday
//                DisclosureGroup("Yesterday", isExpanded: $isExpandedYTD) {
//                    VStack {
//                        List {
//                            OrderCard(isAccepted: true, isOrder: false, showIcon: true)
//                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
//                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
//                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
//                        }
//                        .listStyle(PlainListStyle())
//                        .listRowSeparator(.hidden)
//                        .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.35, alignment: .leading)
//                        .scrollIndicators(.hidden)
//                    }
//                }
//                .font(.customfont(.semibold, fontSize: 16))
//                .frame(maxWidth: .infinity)
//                .foregroundStyle(.black)
//                .accentColor(.black)
//                
//                // Disclosure Group for Last 2 Days
//                DisclosureGroup("Last 2 days", isExpanded: $isExpandedLst2Day) {
//                    VStack {
//                        List {
//                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
//                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
//                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
//                        }
//                        .listStyle(PlainListStyle())
//                        .listRowSeparator(.hidden)
//                        .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.3, alignment: .leading)
//                        .scrollIndicators(.hidden)
//                    }
//                }
//                .font(.customfont(.semibold, fontSize: 16))
//                .frame(maxWidth: .infinity)
//                .foregroundStyle(.black)
//                .accentColor(.black)
//            }
//            .padding(.horizontal, 10)
//            Spacer()
//        }
//    }
//}
//
//
//#Preview {
//    AllTabView()
//}


import SwiftUI

struct AllTabView: View {
    var iselected: Int?
    
    @State private var isExpandedToday = true
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false
    
    var body: some View {
        NavigationStack {
            ScrollView { // Use ScrollView for a more customized look
                VStack(alignment: .leading, spacing: 8) { // Adjust spacing as needed
                    // Disclosure Group for Today
                    DisclosureGroup("Today", isExpanded: $isExpandedToday) {
                        VStack(spacing: 15){
                            OrderCard(isAccepted: true, isOrder: false, showIcon: true)
                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .accentColor(.black)
                    .animation(.easeInOut(duration: 0.3), value: isExpandedToday)
                    
                    // Disclosure Group for Yesterday
                    DisclosureGroup("Yesterday", isExpanded: $isExpandedYTD) {
                        VStack(spacing: 15) {
                            OrderCard(isAccepted: true, isOrder: false, showIcon: true)
                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .accentColor(.black)
                    .animation(.easeInOut(duration: 0.3), value: isExpandedYTD)
                    
                    // Disclosure Group for Last 2 Days
                    DisclosureGroup("Last 2 Days", isExpanded: $isExpandedLst2Day) {
                        VStack(spacing: 15) {
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .accentColor(.black)
                    .animation(.easeInOut(duration: 0.3), value: isExpandedLst2Day)
                }
                .padding(.horizontal)
                .padding(.top, 15)
            }
            .background(Color.clear)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    AllTabView()
}
