import SwiftUI
import SwiftUIFlow

struct SearchScreen: View {
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @ObservedObject var recentSearchesData: RecentSearchesData
    @State private var navigateToResult = false
    @State private var selectedMenuName = ""
    @StateObject private var PopularFoodsData =  PopularFoodVM()
    let suggestedForYou = [
        "Somlor Mju Krerng",
        "Cha Ju Eam",
        "Tongyum",
        "Somlor Kari",
        "Khor",
        "Somlor Jab Chay"
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        // Top bar with back button and title
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.05)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Text("Search")
                                .font(.customfont(.bold, fontSize: geometry.size.width * 0.05))
                                .foregroundColor(.black.opacity(0.84))
                                .padding(.trailing, 20)
                            
                            Spacer()
                        }
                        .padding(.top, geometry.size.height * 0.02)
                        
                        Spacer().frame(height: geometry.size.height * 0.03)
                        
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search items", text: $searchText, onCommit: {
                                performSearchCommit()
                            })
                            .font(.customfont(.medium, fontSize: geometry.size.width * 0.04))
                            .foregroundColor(.black)
                            .padding(.trailing, 12)
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(8)
                        .background(Color(hex: "#F3F2F3"))
                        .cornerRadius(10)
                        .frame(maxWidth: geometry.size.width * 0.95)
                        
                        Spacer().frame(height: geometry.size.height * 0.02)
                        
                        // Recent searches and suggestions
                        VStack {
                            if searchText.isEmpty {
                                // Recent Searches
                                VStack(alignment: .leading, spacing: geometry.size.height * 0.01) {
                                    Text("Recent Searches")
                                        .font(.customfont(.semibold, fontSize: geometry.size.width * 0.045))
                                        .foregroundColor(.black)
                                    
                                    ForEach(Array(recentSearchesData.recentSearches.enumerated()), id: \.offset) { index, search in
                                        Button(action: {
                                            navigateTo(search)
                                        }) {
                                            HStack {
                                                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: geometry.size.width * 0.05)
                                                    .foregroundColor(.gray)
                                                Text(search)
                                                    .font(.customfont(.medium, fontSize: geometry.size.width * 0.04))
                                                    .foregroundColor(.black.opacity(0.60))
                                                Spacer()
                                                
                                                Image(systemName: "multiply")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: geometry.size.width * 0.05)
                                                    .foregroundColor(.gray)
                                                    .onTapGesture {
                                                        recentSearchesData.clearSearch(search, from: modelContext)
                                                    }
                                            }
                                            .padding(.vertical, geometry.size.height * 0.01)
                                        }
                                    }
                                    
                                    Text("Suggested for you")
                                        .font(.customfont(.semibold, fontSize: geometry.size.width * 0.045))
                                        .foregroundColor(.black)
                                    
                                    ScrollView(.vertical) {
                                        Flow(.vertical, alignment: .topLeading) {
                                            ForEach(Array(Set(PopularFoodsData.popularFoodNames.prefix(10))), id: \.self) { suggestion in
                                                Button(action: {
                                                    navigateTo(suggestion)
                                                }) {
                                                    Text(suggestion)
                                                        .font(.customfont(.medium, fontSize: geometry.size.width * 0.035))
                                                        .foregroundColor(PrimaryColor.normalHover)
                                                        .padding(geometry.size.width * 0.02)
                                                        .background(PrimaryColor.lightHover)
                                                        .cornerRadius(geometry.size.width * 0.02)
                                                }
                                            }
                                        }
                                    }

                                }
                            } else {
                                // Filtered results
                                let combinedResults = Array(
                                    Set((recentSearchesData.recentSearches + suggestedForYou).filter { $0.localizedCaseInsensitiveContains(searchText) })
                                )
                                
                                if combinedResults.isEmpty {
                                    Text("This food is not found")
                                        .font(.customfont(.medium, fontSize: geometry.size.width * 0.04))
                                        .foregroundColor(.black.opacity(0.8))
                                        .padding()
                                } else {
                                    ForEach(combinedResults, id: \.self) { result in
                                        Button(action: {
                                            navigateTo(result)
                                        }) {
                                            VStack(alignment: .leading, spacing: geometry.size.height * 0.015) {
                                                HStack {
                                                    Image(systemName: "magnifyingglass")
                                                        .foregroundColor(.gray)
                                                    Text(result)
                                                        .font(.customfont(.medium, fontSize: geometry.size.width * 0.04))
                                                        .foregroundColor(.black.opacity(0.60))
                                                }
                                                Divider()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, geometry.size.width * 0.05)
                }
            }
            .background(
                NavigationLink(
                    destination: ResultSearchView(isTabBarHidden: .constant(true), menuName: selectedMenuName, recentSearchesData: recentSearchesData),
                    isActive: $navigateToResult
                ) {
                    EmptyView()
                }
            )
        }
        .onAppear{
            PopularFoodsData.getAllPopular()
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
    
    private func performSearchCommit() {
        if !searchText.isEmpty {
            navigateTo(searchText)
        }
    }
    
    private func navigateTo(_ menuName: String) {
        guard !menuName.isEmpty else { return }
        selectedMenuName = menuName
        recentSearchesData.saveSearch(menuName, in: modelContext)
        navigateToResult = true
    }
    
}
