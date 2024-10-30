import SwiftUI

struct AllTabView: View {
    
    var iselected: Int?
    
    @State private var isExpandedToday = false
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Disclosure Group for Today
                DisclosureGroup("Today", isExpanded: $isExpandedToday) {
                    VStack {
                        List {
                            OrderCard(isAccepted: true, isOrder: false, showIcon: true)
                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                        }
                        .listStyle(PlainListStyle())
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.3, alignment: .leading)
                    }
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .accentColor(.black)
                
                // Disclosure Group for Yesterday
                DisclosureGroup("Yesterday", isExpanded: $isExpandedYTD) {
                    VStack {
                        List {
                            OrderCard(isAccepted: true, isOrder: false, showIcon: true)
                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                        }
                        .listStyle(PlainListStyle())
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.35, alignment: .leading)
                    }
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .accentColor(.black)
                
                // Disclosure Group for Last 2 Days
                DisclosureGroup("Last 2 days", isExpanded: $isExpandedLst2Day) {
                    VStack {
                        List {
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                        }
                        .listStyle(PlainListStyle())
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.3, alignment: .leading)
                    }
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .accentColor(.black)
            }
            .padding(.horizontal, 10)
            Spacer()
        }
    }
}


#Preview {
    AllTabView()
}
