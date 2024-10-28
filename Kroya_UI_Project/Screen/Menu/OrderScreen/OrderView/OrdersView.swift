import SwiftUI

struct OrdersView: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss

    // Tab Titles
    let tabTitles = ["All", "Order", "Sale"]

    var body: some View {
            VStack(spacing: 0) {
                Spacer().frame(height: 10)
                // Orders Text Header
                HStack {
                    Text("Orders")
                        .font(.customfont(.bold, fontSize: 18))
                        .padding(.leading, 16)
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                Spacer().frame(height: 10)

                // Search Bar
                NavigationLink(destination: SearchScreen()) {
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
                }

                // Tab View
                VStack(alignment: .leading) {
                    // HStack for Tab Titles
                    HStack {
                        ForEach(tabTitles, id: \.self) { title in
                            Text(title)
                                .onTapGesture {
                                    selectedSegment = tabTitles.firstIndex(of: title) ?? 0
                                }
                                .fontWeight(.semibold)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(selectedSegment == (tabTitles.firstIndex(of: title) ?? 0) ? .black.opacity(0.8) : .black.opacity(0.5))
                                .padding(.trailing, 10) // Adjust spacing between titles
                        }
                    }
                    .padding(.horizontal, 15) // Aligns the text with the screen edge
                    .padding(.top)

                    // GeometryReader for underline
                    GeometryReader { geometry in
                        Divider()
                        Rectangle()
                            .fill(PrimaryColor.normal)
                            .frame(width: underlineWidth(for: selectedSegment, in: geometry), height: 2)
                            .offset(x: underlineOffset(for: selectedSegment, in: geometry))
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                    .frame(height: 2) // Divider height
                }
                .padding(.top, 15)

                // TabView for Content
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
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("ico_profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text("User Name")
                                .font(.customfont(.bold, fontSize: 16))
                            Text("Since Oct, 2024")
                                .font(.customfont(.light, fontSize: 12))
                                .foregroundColor(.gray)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { }) {
                        VStack {
                            Text("5")
                                .font(.customfont(.semibold, fontSize: 14))
                                .foregroundColor(.primary)
                            Text("Orders")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        
    }

    // Calculate the underline width dynamically based on the text width
    private func underlineWidth(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let title = tabTitles[selectedSegment]
        let titleWidth = title.size(withAttributes: [NSAttributedString.Key.font: font]).width
        
        // Adjust width if needed
        return titleWidth + 10 // Add padding to the width
    }

    // Calculate the underline offset based on the width of preceding tabs
    private func underlineOffset(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        var offset: CGFloat = 10 // Starting padding

        for index in 0..<selectedSegment {
            let titleWidth = tabTitles[index].size(withAttributes: [NSAttributedString.Key.font: font]).width
            offset += titleWidth + 20 // Add text width + spacing between titles
        }

        return offset
    }
}

#Preview {
    OrdersView()
}

