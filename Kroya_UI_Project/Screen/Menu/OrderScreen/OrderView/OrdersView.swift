import SwiftUI

struct OrdersView: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) var locale
    @State private var languageChangeTrigger = false
    
    var body: some View {
        NavigationView{
            VStack{
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
                    AllTabView(iselected: selectedSegment)
                        .tag(0)
                    OrderTabView(iselected: selectedSegment)
                        .tag(1)
                    SaleTabView(iselected: selectedSegment)
                        .tag(2)
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
        .customFontSemiBoldLocalize(size: 16)

        
    }
    
    // Calculate the underline width dynamically based on the localized text width
    private func underlineWidth(for selectedSegment: Int) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        // Localized titles for calculation
        let localizedTitles = [
            NSLocalizedString("All", comment: ""),
            NSLocalizedString("Order", comment: ""),
            NSLocalizedString("Sale", comment: "")
        ]
        
        // Calculate the width based on the localized title
        let title = localizedTitles[selectedSegment]
        let titleWidth = title.size(withAttributes: [NSAttributedString.Key.font: font]).width
        return locale.identifier == "ko" ? titleWidth + 30 : locale.identifier == "km-KH" ? titleWidth + 30 : titleWidth + 10
    }
    
    // Calculate the underline offset based on the localized width of preceding tabs
    private func underlineOffset(for selectedSegment: Int) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let localizedTitles = [
            NSLocalizedString("All", comment: ""),
            NSLocalizedString("Order", comment: ""),
            NSLocalizedString("Sale", comment: "")
        ]

        var offset: CGFloat = 10
        for index in 0..<selectedSegment {
            let titleWidth = localizedTitles[index].size(withAttributes: [NSAttributedString.Key.font: font]).width
            offset += (locale.identifier == "ko") ? (titleWidth + 20) :
                      (locale.identifier == "km-KH") ? (titleWidth + 35) : (titleWidth + 20)
        }

        return offset
    }
}
