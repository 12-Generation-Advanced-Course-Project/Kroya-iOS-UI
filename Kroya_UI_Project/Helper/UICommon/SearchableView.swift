



import SwiftUI
import SwiftUIFlow

struct SearchScreen: View {
    @State private var searchText = ""
    @State private var isSearching = false
    
    @Environment(\.dismiss) var dismiss
    let recentSearches = ["Noodles", "Pizza", "Burger", "Somlor Mju Krerng", "Cha Ju Eam", "Tongyum", "Somlor Kari", "Khor"]
    let suggestedForYou = ["Somlor Mju Krerng", "Cha Ju Eam", "Tongyum", "Somlor Kari", "Khor", "Somlor Jab Chay","asdasd","as33333jk3k","fkkfkkfkkf","ooososos","asdddsdasd","ssddooooooo","ddd,dmddnndn","dddosddsd"]
    
    // Define grid layout
    let columns = [
        GridItem(.flexible(minimum: 50), spacing: 10),
        GridItem(.flexible(minimum: 50), spacing: 10)
    ]
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Header with back button
                    HStack {
                        Button(action: {
                            dismiss()
                            
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .foregroundColor(.black)
                        }
                        
                        Spacer().frame(width: 35)
                        Text("Search")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.black.opacity(0.84))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    
                    Spacer().frame(height: 20)
                    
                    // Search field
                    HStack {
                        Image("ico_search1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        TextField("Search items", text: $searchText)
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(.gray)
                            .padding(.trailing, 12)
                        Spacer()
                        if !searchText.isEmpty { // Show clear button if searchText is not empty
                            Button(action: {
                                searchText = ""
                            }) {
                                Image("CancelButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing)
                            }
                        }
                    }
                    .padding(.leading, 12)
                    .frame(width: .screenWidth * 0.9, height: .screenHeight * 0.05)
                    .background(Color(hex: "#F3F2F3"))
                    .cornerRadius(12)
                    
                    Spacer().frame(height: 20)
                    
                    VStack {
                        if searchText.isEmpty {
                            // Recent Searches
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Recent Searches")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .foregroundColor(.black)
                                
                                ForEach(Array(recentSearches.enumerated()), id: \.offset) { index, search in
                                    HStack {
                                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 28, height: 28)
                                            .foregroundStyle(.gray)
                                        Spacer().frame(width: 10)
                                        Text(search)
                                            .font(.customfont(.medium, fontSize: 16))
                                            .foregroundColor(.black.opacity(0.60))
                                        Spacer()
                                        Image(systemName: "multiply")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(.gray)
                                            .onTapGesture {
                                                print("Remove \(search) from recent searches")
                                            }
                                    }
                                    .frame(width: .screenWidth * 0.86, height: .screenHeight * 0.04, alignment: .leading)
                                }
                                
                                ScrollView(.vertical){
                                    Flow(.vertical,alignment: .topLeading){
                                        ForEach(suggestedForYou, id: \.self) { suggestion in
                                            Text(suggestion)
                                                .font(.customfont(.medium, fontSize: 12))
                                                .foregroundColor(PrimaryColor.normalHover)
                                                .padding(10)
                                                .background(PrimaryColor.lightHover)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    print("Selected suggestion: \(suggestion)")
                                                }
                                        }
                                    }
                                }
                                
                                // Suggested for You
                                //                                GeometryReader { geometry in
                                //                                    VStack(alignment: .leading) {
                                //                                        Text("Suggested for You")
                                //                                            .font(.customfont(.semibold, fontSize: 16))
                                //                                            .foregroundColor(.black)
                                //                                        FlowLayout(items: suggestedForYou, itemSpacing: 4, lineSpacing: 10) { suggestion in
                                //                                            Text(suggestion)
                                //                                                .font(.customfont(.medium, fontSize: 12))
                                //                                                .foregroundColor(PrimaryColor.normalHover)
                                //                                                .padding(10)
                                //                                                .background(PrimaryColor.lightHover)
                                //                                                .cornerRadius(10)
                                //                                                .onTapGesture {
                                //                                                    print("Selected suggestion: \(suggestion)")
                                //                                                }
                                //                                        }
                                //                                        .position(x: geometry.size.width * 0.49, y: geometry.size.height * -0.18)
                                //                                    }
                                //                                }
                                //                                .frame(width: .screenWidth * 0.9, height: .screenHeight * 0.25)
                            }
                        } else {
                            // Search Results
                            let combinedResults = Array(Set((recentSearches + suggestedForYou).filter { $0.localizedCaseInsensitiveContains(searchText) }))
                            
                            ForEach(combinedResults, id: \.self) { result in
                                VStack(alignment: .leading, spacing: 15) {
                                    Spacer().frame(height: 5)
                                    HStack {
                                        Image("ico_search1")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                        Text(result)
                                            .font(.customfont(.medium, fontSize: 16))
                                            .foregroundStyle(.black.opacity(0.60))
                                    }
                                    Divider()
                                }
                                .onTapGesture {
                                    print("Selected result: \(result)")
                                }
                            }
                        }
                    }
                    .frame(width: .screenWidth * 0.9)
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    SearchScreen()
}
