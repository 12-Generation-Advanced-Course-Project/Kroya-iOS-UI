import SwiftUI
struct FavoriteViewCart: View {
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @StateObject private var favorite = FavoriteVM()
   
    var body: some View {
        VStack(spacing: 0) {
            // Segment Header
            VStack {
                HStack {
                    Spacer()
                    
                    Text("Food on Sale")
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            selectedSegment = 0
                        }
                    
                    Spacer()
                    
                    Text("Recipes")
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            selectedSegment = 1
                        }
                    
                    Spacer()
                }
                .padding(.top)
                
                // Underline for selected segment
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width / 2, height: 2)
                        .offset(x: selectedSegment == 1 ? geometry.size.width / 2 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                }
                .frame(height: 2)
            }
            
            // TabView Content
            TabView(selection: $selectedSegment) {
                FavoriteFoodOnSaleTabView(searchText: $searchText) // Pass searchText as Binding
                    .tag(0)
                
                FavoriteRecipesTabView(searchText: $searchText) // Pass searchText as Binding
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .searchable(text: $searchText, prompt: LocalizedStringKey("Search Item"))
        .navigationBarTitle("Favorite", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            }
        }
    }
}
