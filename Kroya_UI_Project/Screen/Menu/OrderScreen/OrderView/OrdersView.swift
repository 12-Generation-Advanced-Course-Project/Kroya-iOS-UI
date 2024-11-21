
import SwiftUI

struct OrdersView: View {
    
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) var locale
    @State private var languageChangeTrigger = false
    
    // OrderViewModel instance
    @StateObject private var orderViewModel = OrderViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Tab View
                VStack(alignment: .leading) {
                    HStack {
                        Text(LocalizedStringKey("All"))
                            .onTapGesture {
                                selectedSegment = 0
                            }
                            .customFontSemiBoldLocalize(size: 16)
                            .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                            .padding(.trailing, 10)
                        
                        Text(LocalizedStringKey("Order"))
                            .onTapGesture {
                                selectedSegment = 1
                            }
                            .customFontSemiBoldLocalize(size: 16)
                            .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                            .padding(.trailing, 10)
                        
                        Text(LocalizedStringKey("Sale"))
                            .onTapGesture {
                                selectedSegment = 2
                            }
                            .customFontSemiBoldLocalize(size: 16)
                            .foregroundColor(selectedSegment == 2 ? .black.opacity(0.8) : .black.opacity(0.5))
                            .padding(.trailing, 10)
                    }
                    .padding(.horizontal, 15)
                    .padding(.top)
                    
                    // GeometryReader for underline
                    GeometryReader { geometry in
                        Divider()
                        Rectangle()
                            .fill(PrimaryColor.normal)
                            .frame(width: underlineWidth(for: selectedSegment), height: 2)
                            .offset(x: underlineOffset(for: selectedSegment))
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                    .frame(height: 2)
                }
                
                // TabView for Content
                TabView(selection: $selectedSegment) {
                    AllTabView()
                        .tag(0)
                        .environmentObject(orderViewModel)
                    OrderTabView()
                        .tag(1)
                        .environmentObject(orderViewModel)
                    SaleTabView()
                        .tag(2)
                        .environmentObject(orderViewModel)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Text("Orders")
                .customFontBoldLocalize(size: 16)
            )
        }
        .searchable(text: $searchText, prompt: "Search Item")
        .onChange(of: searchText) { newValue in
            if newValue.isEmpty {
//                orderViewModel.fetchAllPurchase()
            } else {
                // Example of client-side filtering (for testing)
                orderViewModel.orders = orderViewModel.orders.filter { $0.name.contains(newValue) }
            }
        }

        .customFontSemiBoldLocalize(size: 16)
        .onAppear {
            orderViewModel.fetchAllPurchase()
        }
    }
    
    private func underlineWidth(for selectedSegment: Int) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let localizedTitles = [
            NSLocalizedString("All", comment: ""),
            NSLocalizedString("Order", comment: ""),
            NSLocalizedString("Sale", comment: "")
        ]
        let title = localizedTitles[selectedSegment]
        let titleWidth = title.size(withAttributes: [NSAttributedString.Key.font: font]).width
        switch locale.identifier {
        case "ko":
            return titleWidth + 16.5
        case "km-KH":
            return 46
        default:
            return titleWidth + 10
        }
    }
    
    private func underlineOffset(for selectedSegment: Int) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let localizedTitles = [
            NSLocalizedString("All", comment: ""),
            NSLocalizedString("Order", comment: ""),
            NSLocalizedString("Sale", comment: "")
        ]
        var offset: CGFloat = 15 // Initial padding
        for index in 0..<selectedSegment {
            let titleWidth = localizedTitles[index].size(withAttributes: [NSAttributedString.Key.font: font]).width
            offset += (locale.identifier == "ko") ? (titleWidth + 23.5) :
                      (locale.identifier == "km-KH") ? (64) : (titleWidth + 15.5)
        }
        return offset
    }
}
