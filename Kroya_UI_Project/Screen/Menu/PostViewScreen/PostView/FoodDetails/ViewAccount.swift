import SwiftUI
import SDWebImageSwiftUI

struct ViewAccount: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    var userId: Int
    @StateObject private var viewAccount = ViewaccountViewmodel()

    // Tab Titles
    let tabTitles = ["All", "Food on Sale", "Recipes"]

    var body: some View {
        VStack {
            Spacer().frame(height: 10)

            // Orders Text Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 23)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 10)

            // Profile
            HStack(spacing: 10) {
                // Profile Image
                if let url = URL(string: "https://kroya-api-production.up.railway.app/api/v1/fileView/\(viewAccount.profileImage)") {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                } else {
                    // Fallback placeholder image
                    Image("user")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }

                // User Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewAccount.fullName)
                        .font(.customfont(.bold, fontSize: 17))
                        .foregroundColor(.black)

                    Text(viewAccount.email)
                        .font(.customfont(.regular, fontSize: 14))
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding(.horizontal, 15)

            // Tab View
            VStack(alignment: .leading) {
                // HStack for the Tab Titles
                HStack {
                    ForEach(tabTitles.indices, id: \.self) { index in
                        Text(tabTitles[index])
                            .onTapGesture {
                                selectedSegment = index
                            }
                            .fontWeight(.semibold)
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(selectedSegment == index ? .black.opacity(0.8) : .black.opacity(0.5))
                            .padding(.trailing, 10)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top)

                // Geometry Reader for Underline
                GeometryReader { geometry in
                    Divider()
                    Rectangle()
                        .fill(PrimaryColor.normal)
                        .frame(width: underlineWidth(for: selectedSegment, in: geometry), height: 2)
                        .offset(x: underlineOffset(for: selectedSegment, in: geometry))
                        .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                }
                .frame(height: 2)
            }
            .padding(.top, 5)

            // TabView for Content
            TabView(selection: $selectedSegment) {
                AllUserFoodView(ViewAccountUser: viewAccount, isSelected: selectedSegment)
                    .tag(0)
                UserFoodSell(iselected: selectedSegment, ViewAccountUser: viewAccount)
                    .tag(1)
                UserFoodRecipe(ViewAccountUser: viewAccount, iselected: selectedSegment)
                    .tag(2)
            }
            .padding(.top, 8)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .onAppear {
            viewAccount.fetchAllUserFoodData(userId: userId)
        }
        .navigationBarBackButtonHidden(true)
    }

    // Helper functions for underline calculation remain the same
    // Calculate the underline width dynamically based on the text width
    private func underlineWidth(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let title = tabTitles[selectedSegment]
        let titleWidth = title.size(withAttributes: [NSAttributedString.Key.font: font]).width

        // Add or subtract a fixed value from the calculated width
        let widthAdjustment: CGFloat = 10 // Adjust this value to add/subtract pixels from the underline width
        return titleWidth + widthAdjustment
    }

    // Calculate the underline offset based on the cumulative width of the previous text items
    private func underlineOffset(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        var offset: CGFloat = 15 // Starting padding from the leading edge

        for index in 0..<selectedSegment {
            let titleWidth = tabTitles[index].size(withAttributes: [NSAttributedString.Key.font: font]).width
            offset += titleWidth + 17.5
        }

        return offset
    }

}

