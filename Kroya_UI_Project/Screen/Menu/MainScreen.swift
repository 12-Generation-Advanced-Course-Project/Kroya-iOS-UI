import SwiftUI

struct MainScreen: View {
    @State private var selectedTab = 1
    @Environment(\.presentationMode) var presentationMode
    @State private var isTabBarHidden: Bool = false
    @State private var isModalPresented: Bool = false
    
    
    @State private var tabBarVisible: Bool = false
    var body: some View {
        ZStack {
            VStack (spacing: 20) {
                TabView(selection: $selectedTab) {
                    NavigationView{
                        HomeView()
                    }
                    .tabItem {
                        VStack {
                            Image(selectedTab == 1 ? "icon-home-Color" : "ico-home")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                            Text("Home")
                                .font(.customfont(selectedTab == 1 ? .regular : .semibold, fontSize: selectedTab == 1 ? 18 : 16))
                                .foregroundColor(selectedTab == 1 ? PrimaryColor.normal : .black)
                        }
                    }
                    .tag(1)
                    
                    NavigationView {
                        FavoriteView(isTabBarHidden: $isTabBarHidden)
                    }.tabItem {
                        VStack {
                            Image(selectedTab == 2 ? "icon-heart-Color" : "ico-heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                            Text("Favorite")
                                .font(.customfont(selectedTab == 2 ? .bold : .semibold, fontSize: selectedTab == 2 ? 18 : 16))
                                .foregroundColor(selectedTab == 2 ? PrimaryColor.normal : .black)
                        }
                        
                    }
                    .padding(.horizontal,10)
                    .tag(2)
                    
                    Spacer()
                    
                    NavigationView{
                        OrdersView(isTabBarHidden: $isTabBarHidden)
                    }.tabItem {
                        VStack {
                            Image(selectedTab == 3 ? "icon-shopbag-Color" : "ico-shopbag")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                            Text("Order")
                                .font(.customfont(selectedTab == 3 ? .bold : .semibold, fontSize: selectedTab == 3 ? 18 : 16))
                                .foregroundColor(selectedTab == 3 ? PrimaryColor.normal : .black)
                        }
                    }
                    .tag(3)
                    NavigationView{
                        ProfileView()
                    }
                    .tabItem {
                        VStack {
                            Image(selectedTab == 4 ? "icon-User-Color" : "ico-User")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                            Text("Me")
                                .font(.customfont(selectedTab == 4 ? .bold : .semibold, fontSize: selectedTab == 4 ? 18 : 16))
                                .foregroundColor(selectedTab == 4 ? PrimaryColor.normal : .black)
                        }
                    }.tag(4)
                    
                }
                .padding(.top, 20)
                .accentColor(PrimaryColor.normal)
                if !isTabBarHidden {
                    GeometryReader { geometry in
                        Divider().frame(height: 0.1).background(.black.opacity(0.1))
                        HStack {
                            Spacer()
                                .frame(width: getSpacerWidth(for: selectedTab, geometry: geometry))
                            Rectangle()
                                .fill(PrimaryColor.normal)
                                .frame(width: geometry.size.width / 5, height: 2)
                            Spacer()
                        }
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    }
                    .frame(height: 2)
                    .offset(y:-70)
                }
                
            }
            .frame(width: .screenWidth, height: .screenHeight)
            .padding(.bottom, 50)
            
            if !isTabBarHidden{
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Button(action: {
                            isModalPresented.toggle()
                        }, label: {
                            ZStack {
                                Rectangle()
                                    .fill(PrimaryColor.normal)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(23)
                                Image("ChefHead")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                        })
                        .frame(width: 100,height: 100)
                        .padding(20)
                        .cornerRadius(10)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.87)
                    }
                }
            }
            
        }
        .fullScreenCover(isPresented: $isModalPresented, content: {
            AddFoodView()
        })
        .navigationBarBackButtonHidden(true)
    }
    
    private func getSpacerWidth(for selectedTab: Int, geometry: GeometryProxy) -> CGFloat {
        switch selectedTab {
        case 2: // Favorite Tab
            return (geometry.size.width / 5.20) * CGFloat(selectedTab - 1)
        case 3: // Orders Tab
            return (geometry.size.width / 3.30) * CGFloat(selectedTab - 1)
        case 4: // Profile Tab
            return (geometry.size.width / 3.75) * CGFloat(selectedTab - 1)
        default: // Other Tabs
            return (geometry.size.width / 3.30) * CGFloat(selectedTab - 1)
        }
    }
}

#Preview {
    MainScreen()
}
