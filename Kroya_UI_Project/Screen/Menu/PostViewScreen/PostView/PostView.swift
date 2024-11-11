//
//  FavoriteView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 30/9/24.
//

import SwiftUI
import Combine
import Kingfisher
struct PostViewScreen: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    var urlImagePost: String = "https://kroya-api.up.railway.app/api/v1/fileView/"
    @Environment(\.dismiss) var dismiss
    @StateObject private  var Profile = ProfileViewModel()
    var tabTitles = ["All", "Food on Sale", "Recipes"]
    
    var body: some View {
        
        ZStack{
            VStack {
                HStack {
                    HStack {
                        if let profileImageUrl = Profile.userProfile?.profileImage, !profileImageUrl.isEmpty,
                           let imageUrl = URL(string: Constants.fileupload + profileImageUrl) {
                            KFImage(imageUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                        } else {
                            Image("user-profile") // Placeholder image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        VStack(alignment: .leading) {
                            // Display "N/A" if fullName is nil or empty
                            Text(Profile.userProfile?.fullName?.isEmpty == false ? Profile.userProfile?.fullName ?? "N/A" : "N/A")
                                .customFontBoldLocalize(size: 16)
                                .foregroundStyle(.black)

                            Spacer().frame(height: 5)
                            
                            // Display "N/A" if email is nil or empty
                            Text(Profile.userProfile?.email?.isEmpty == false ? Profile.userProfile?.email ?? "N/A" : "N/A")
                                .customFontLightLocalize(size: 12)
                                .foregroundStyle(.black)
                        }

                    }

                    Spacer()
                    Button(action: { }) {
                        VStack {
                            Text("6")
                                .customFontMediumLocalize(size: 14)
                                .foregroundStyle(PrimaryColor.normal)
                            Text("Post")
                                .customFontMediumLocalize(size: 14)
                                .foregroundStyle(.black)
                        }
                    }
                    
                }
                .padding(.horizontal,20)
                Spacer().frame(height: .screenHeight * 0.01)
                // Tab View
                VStack(alignment: .leading) {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text(LocalizedStringKey("All"))
                                .customFontSemiBoldLocalize(size: 16)
                                .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                                .onTapGesture {
                                    selectedSegment = 0
                                }
                            
                            Spacer()
                            
                            Text(LocalizedStringKey("Food on Sale"))
                                .customFontSemiBoldLocalize(size: 16)
                                .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                                .onTapGesture {
                                    selectedSegment = 1
                                }
                            
                            Spacer()
                            
                            Text(LocalizedStringKey("Recipes"))
                                .customFontSemiBoldLocalize(size: 16)
                                .foregroundColor(selectedSegment == 2 ? .black.opacity(0.8) : .black.opacity(0.5))
                                .onTapGesture {
                                    selectedSegment = 2
                                }
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        GeometryReader { geometry in
                            Divider()
                            
                            Rectangle()
                                .fill(Color.yellow) // Use your defined color here
                                .frame(width: geometry.size.width / 3, height: 2) // Three segments
                                .offset(x: CGFloat(selectedSegment) * (geometry.size.width / 3))
                                .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                        }
                        .frame(height: 2)
                    }
                }
                // TabView for content
                TabView(selection: $selectedSegment) {
                    FoodSaleandRecipeView(iselected: selectedSegment)
                        .tag(0)
                    FoodOnSaleView(iselected: selectedSegment)
                        .tag(1)
                    UserFoodRecipeTab(iselected: selectedSegment)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .onAppear{
            Profile.fetchUserProfile()
        }
        .onDisappear{
            Profile.fetchUserProfile()
        }
    }
    
    
    //// Calculate the underline width dynamically based on the text width
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
        // Calculate the width of the preceding tabs
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        var offset: CGFloat = 10 // Starting padding from the leading edge
        
        for index in 0..<selectedSegment {
            let titleWidth = tabTitles[index].size(withAttributes: [NSAttributedString.Key.font: font]).width
            offset += titleWidth + 20 // Add the width of the text and the trailing padding between titles
        }
        
        return offset
    }
}
