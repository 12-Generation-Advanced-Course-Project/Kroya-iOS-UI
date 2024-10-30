
// New Code
// 29/10/24
// Hengly


import SwiftUI
import SwiftUIFlow

struct SearchScreen: View {
    @State private var searchText = ""
    @State private var isSearching = false
    
    @Environment(\.dismiss) var dismiss
    let recentSearches = ["Somlor Kari", "Stack", "BayChar Loklak", "Amork", "Noodles", "Koung", "Fried fish", "Char Kroeng"]
    let suggestedForYou = ["Somlor Mju Krerng", "Cha Ju Eam", "Tongyum", "Somlor Kari", "Khor", "Somlor Jab Chay", "asdasd", "as33333jk3k", "fkkfkkfkkf", "ooososos", "asdddsdasd", "ssddooooooo", "ddd,dmddnndn", "dddosddsd"]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: geometry.size.width * 0.05)
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
                        
                        HStack {
                            Image("ico_search1")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geometry.size.width * 0.05)
                            TextField(LocalizedStringKey("Search items"), text: $searchText)
                                .font(.customfont(.medium, fontSize: geometry.size.width * 0.04)) // Responsive font
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                            
                            Spacer()
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image("CancelButton")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: geometry.size.width * 0.05)
                                        .padding(.trailing)
                                }
                            }
                        }
                        .padding(.leading, 12)
                        .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.05)
                        .background(Color(hex: "#F3F2F3"))
                        .cornerRadius(12)
                        
                        Spacer().frame(height: geometry.size.height * 0.02)
                        
                        VStack {
                            if searchText.isEmpty {
                                VStack(alignment: .leading, spacing: geometry.size.height * 0.01) {
                                    Text(LocalizedStringKey("Recent Searches"))
                                        .font(.customfont(.semibold, fontSize: geometry.size.width * 0.045))
                                        .foregroundColor(.black)
                                    
                                    ForEach(Array(recentSearches.enumerated()), id: \.offset) { index, search in
                                        HStack {
                                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: geometry.size.width * 0.05)
                                                .foregroundStyle(.gray)
                                            Spacer().frame(width: geometry.size.width * 0.02)
                                            Text(search)
                                                .font(.customfont(.medium, fontSize: geometry.size.width * 0.04))
                                                .foregroundColor(.black.opacity(0.60))
                                            Spacer()
                                            Image(systemName: "multiply")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: geometry.size.width * 0.05)
                                                .foregroundStyle(.gray)
                                                .onTapGesture {
                                                    print("Remove \(search) from recent searches")
                                                }
                                        }
                                        .padding(.vertical, geometry.size.height * 0.01)
                                    }
                                    
                                    ScrollView(.vertical) {
                                        Flow(.vertical, alignment: .topLeading) {
                                            ForEach(suggestedForYou, id: \.self) { suggestion in
                                                Text(suggestion)
                                                    .font(.customfont(.medium, fontSize: geometry.size.width * 0.035))
                                                    .foregroundColor(PrimaryColor.normalHover)
                                                    .padding(geometry.size.width * 0.02)
                                                    .background(PrimaryColor.lightHover)
                                                    .cornerRadius(geometry.size.width * 0.02)
                                                    .onTapGesture {
                                                        print("Selected suggestion: \(suggestion)")
                                                    }
                                            }
                                        }
                                    }
                                }
                            } else {
                                // Filtered results combining recent searches and suggestions
                                let combinedResults = Array(Set((recentSearches + suggestedForYou).filter { $0.localizedCaseInsensitiveContains(searchText) }))
                                
                                // Check if combinedResults is empty and show the "not found" message
                                if combinedResults.isEmpty {
                                    Text("This food is not found")
                                        .font(.customfont(.medium, fontSize: geometry.size.width * 0.04))
                                        .foregroundColor(.black)
                                        .padding()
                                } else {
                                    ForEach(combinedResults, id: \.self) { result in
                                        NavigationLink(destination: ResultSearchView(isTabBarHidden: .constant(true), menuName: result)) {
                                            VStack(alignment: .leading, spacing: geometry.size.height * 0.015) {
                                                Spacer().frame(height: geometry.size.height * 0.01)
                                                HStack {
                                                    Image("ico_search1")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(maxWidth: geometry.size.width * 0.05)
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
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SearchScreen()
}
