import SwiftUI

struct OrdersView: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) var locale
    @State private var languageChangeTrigger = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 10)
            
            // Orders Text Header
            HStack {
                Text("Orders")
                    .font(.customfont(.bold, fontSize: 18))
                    .padding(.leading, 20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 10)
            
            // Search Bar
            NavigationLink(destination: SearchScreen()) {
                HStack {
                    Image("ico_search1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Search Item")
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
            }
            
            // Tab View
            VStack(alignment: .leading) {
                // HStack for Tab Titles with localized strings
                HStack {
                    Text(LocalizedStringKey("All"))
                        .onTapGesture {
                            selectedSegment = 0
                        }
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .padding(.trailing, 10)
                    
                    Text(LocalizedStringKey("Order"))
                        .onTapGesture {
                            selectedSegment = 1
                        }
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .padding(.trailing, 10)
                    
                    Text(LocalizedStringKey("Sale"))
                        .onTapGesture {
                            selectedSegment = 2
                        }
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
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
            .padding(.top, 15)
            
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
        .navigationBarHidden(true)
        .onChange(of: locale) { _ in
            // Trigger view update when language changes
            languageChangeTrigger.toggle()
        }
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
        return titleWidth + 10
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
            offset += titleWidth + 20 // Adjust spacing as needed
        }
        
        return offset
    }
}
