
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
                            NavigationLink(destination: OrderListView()){
                                OrderCard(isAccepted: true, isOrder: false, showIcon: true)
                            }
                            NavigationLink(destination:
//                            FoodDetailView(
//                                theMainImage: "Songvak",
//                                subImage1: "ahmok",
//                                subImage2: "brohok",
//                                subImage3: "SomlorKari",
//                                subImage4: "Songvak",
//                                showOrderButton: false,
//                                showPrice: true,
//                                showButtonInvoic: true,
//                                invoiceAccept: false
//                            )
                                           EmptyView()
                            ){
                                OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            }
                            
                            NavigationLink(destination:
//                                            FoodDetailView(
//                                theMainImage: "Songvak",
//                                subImage1: "ahmok",
//                                subImage2: "brohok",
//                                subImage3: "SomlorKari",
//                                subImage4: "Songvak",
//                                showOrderButton: false,
//                                showPrice: true,
//                                showButtonInvoic: true,
//                                invoiceAccept: true
//                                
//                            )
                                           EmptyView()
                            ){
                                OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            }}
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .accentColor(.black)
                    .animation(.easeInOut(duration: 0.3), value: isExpandedToday)
                    
                    // Disclosure Group for Yesterday
                    DisclosureGroup("Yesterday", isExpanded: $isExpandedYTD) {
                        VStack(spacing: 15) {
                            NavigationLink(destination: OrderListView()){
                                OrderCard(isAccepted: true, isOrder: false, showIcon: true)
                            }
                            
                            NavigationLink(destination:
//                                            FoodDetailView(
//                                theMainImage: "Songvak",
//                                subImage1: "ahmok",
//                                subImage2: "brohok",
//                                subImage3: "SomlorKari",
//                                subImage4: "Songvak",
//                                showOrderButton: false,
//                                showPrice: true,
//                                showButtonInvoic: true,
//                                invoiceAccept: false
//                            )
                                           EmptyView()
                            ){
                                OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            }
                            
                            NavigationLink(destination:
//                            FoodDetailView(
//                                theMainImage: "Songvak",
//                                subImage1: "ahmok",
//                                subImage2: "brohok",
//                                subImage3: "SomlorKari",
//                                subImage4: "Songvak",
//                                showOrderButton: false,
//                                showPrice: true,
//                                showButtonInvoic: true,
//                                invoiceAccept: true
//                            )
                                           EmptyView()
                            ){
                                OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            }
                        }
                    }
                    .customFontSemiBoldLocalize(size: 16)
                    .foregroundColor(.black)
                    .accentColor(.black)
                    .animation(.easeInOut(duration: 0.3), value: isExpandedYTD)
                    
                    // Disclosure Group for Last 2 Days
                    DisclosureGroup("Last 2 days", isExpanded: $isExpandedLst2Day) {
                        VStack(spacing: 15) {
                            
                            NavigationLink(destination:
//                                            FoodDetailView(
//                                theMainImage: "Songvak",
//                                subImage1: "ahmok",
//                                subImage2: "brohok",
//                                subImage3: "SomlorKari",
//                                subImage4: "Songvak",
//                                showOrderButton: false,
//                                showPrice: true,
//                                showButtonInvoic: true,
//                                invoiceAccept: true
//                            )
                                           EmptyView()
                            ){
                                OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            }
                            
                            NavigationLink(destination:
//                                            FoodDetailView(
//                                theMainImage: "Songvak",
//                                subImage1: "ahmok",
//                                subImage2: "brohok",
//                                subImage3: "SomlorKari",
//                                subImage4: "Songvak",
//                                showOrderButton: false,
//                                showPrice: true,
//                                showButtonInvoic: true,
//                                invoiceAccept: false
//                            )
                                           EmptyView()
                            ){
                                OrderCard(isAccepted: false, isOrder: true, showIcon: false)
                            }
                            
                            NavigationLink(destination:
//                                            FoodDetailView(
//                                theMainImage: "Songvak",
//                                subImage1: "ahmok",
//                                subImage2: "brohok",
//                                subImage3: "SomlorKari",
//                                subImage4: "Songvak",
//                                showOrderButton: false,
//                                showPrice: true,
//                                showButtonInvoic: true,
//                                invoiceAccept: true
//                            )
                                           EmptyView()
                            ){
                                OrderCard(isAccepted: true, isOrder: true, showIcon: false)
                            }}
                    }
                    .customFontSemiBoldLocalize(size: 16)
                    .foregroundColor(.black)
                    .accentColor(.black)
                    .animation(.easeInOut(duration: 0.3), value: isExpandedLst2Day)
                }
                .padding(.horizontal)
                .padding(.top, 5)
            }
            .background(Color.clear)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    AllTabView()
}
 
