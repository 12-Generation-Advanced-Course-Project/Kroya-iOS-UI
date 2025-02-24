import SwiftUI

struct MainScreen: View {
    @State private var selectedTab = 1
    @State var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isModalPresented: Bool = false
    @State private var showGuestAlert = false
    @EnvironmentObject var userStore: UserStore
//    @StateObject private var authVM: AuthViewModel
    @EnvironmentObject var authVM: AuthViewModel
//    @StateObject private var draftModelData: DraftModelData
    @StateObject private var draftModelData = DraftModelData()
    @Environment(\.modelContext) var modelContext
    @Binding var lang: String
    @State private var showLoadingOverlay = false
    // hengly 26/11/24
    var sellerId:Int
//    init(userStore: UserStore, lang: Binding<String>) {
//        _authVM = StateObject(wrappedValue: AuthViewModel(userStore: userStore))
////        _addressViewModel = StateObject(wrappedValue: AddressViewModel())
//        _draftModelData = StateObject(wrappedValue: DraftModelData(userStore: userStore))
//        self._lang = lang
//    }
    public init(lang: Binding<String>) {
        self._lang = lang
        // hengly 26/11/24
        self.sellerId = 0
        _draftModelData = StateObject(wrappedValue: DraftModelData())
    }

    
    var body: some View {
        
//        NavigationView {
            ZStack {
                VStack(spacing: 10) {
                    TabView(selection: $selectedTab) {
                        // hengly 26/11/24
                        HomeView( sellerId: sellerId)
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
                        
                            PostViewScreen()
                       
                            .tabItem {
                                VStack {
                                    Image(selectedTab == 2 ? "PostVectorYellow" : "PostVector")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                    Text("Post")
                                        .font(.customfont(selectedTab == 2 ? .bold : .semibold, fontSize: selectedTab == 2 ? 18 : 16))
                                        .foregroundColor(selectedTab == 2 ? PrimaryColor.normal : .black)
                                }
                            }
                            .tag(2)
                        
                        Spacer()
                        
                        OrdersView()
                            .tabItem {
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
                        
//                        ProfileView(authVM: authVM, lang: $lang)
                        ProfileView(lang: $lang)
                            .environmentObject(userStore)
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
                            }
                            .tag(4)
                    }
                    .padding(.top, 30)
                    .accentColor(PrimaryColor.normal)
                    .onChange(of: selectedTab) { newTab in
                        handleTabChange(to: newTab)
                    }
                    
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
                    .offset(y: -(.screenHeight * 0.0715))
                }
                .frame(width: .screenWidth, height: .screenHeight)
                .padding(.bottom, .screenHeight * 0.072)
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Button(action: {
                            if Auth.shared.isUserLoggedIn() == false {
                                withAnimation{
                                    showGuestAlert = true
                                }
                            } else {
                                isModalPresented.toggle()
                            }
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(PrimaryColor.normal)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(23)
                                Image("ChefHead")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                        }
                        .frame(width: 100, height: 100)
                        .padding(20)
                        .cornerRadius(10)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.86)
                    }
                }
                // Loading overlay
                if showLoadingOverlay {
                    LoadingOverlay()
                }
                
                // Custom alert overlay
                if showGuestAlert {
                    LoginAlertView(
                        onCancel: { showGuestAlert = false },
                        onLogin: {
                            showLoadingOverlay = true
                            showGuestAlert = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showLoadingOverlay = false
                                navigateToLogin()
                            }
                        }
                    )
                }
            }
            .frame(width: .screenWidth, height: .screenHeight)
//        }
//        .edgesIgnoringSafeArea(.all)
//        .ignoresSafeArea()
        .onAppear {
//            addressViewModel.fetchAllAddresses()
            draftModelData.loadDraft(from: modelContext)
        }
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isModalPresented) {
            AddFoodView(
                rootIsActive1: $isActive,
                dismissToRoot: { isModalPresented = false },
                draftModelData: draftModelData
            )
            .environment(\.modelContext, modelContext)
        }
    }
    
    private func handleTabChange(to newTab: Int) {
        // Only allow access to other tabs if the user is logged in
        if Auth.shared.isUserLoggedIn() == false && newTab != 1 {
            withAnimation{
                showGuestAlert = true
            }
            selectedTab = 1
        } else {
            selectedTab = newTab
        }
    }
    
    private func navigateToLogin() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootWindow = windowScene.windows.first {
            rootWindow.rootViewController = UIHostingController(
                rootView:
//                    LoginScreenView(userStore: userStore, lang: $lang)
                    LoginScreenView(lang: $lang)
                    .environmentObject(userStore)
                    .environmentObject(authVM)
//                    .environmentObject(Auth.shared)
//                    .environmentObject(addressViewModel)
            )
            rootWindow.makeKeyAndVisible()
        }
    }
    
    private func getSpacerWidth(for selectedTab: Int, geometry: GeometryProxy) -> CGFloat {
        switch selectedTab {
        case 2:
            return (geometry.size.width / 5.20) * CGFloat(selectedTab - 1)
        case 3:
            return (geometry.size.width / 3.30) * CGFloat(selectedTab - 1)
        case 4:
            return (geometry.size.width / 3.75) * CGFloat(selectedTab - 1)
        default:
            return (geometry.size.width / 3.30) * CGFloat(selectedTab - 1)
        }
    }
}

//#Preview {
//    MainScreen(userStore: UserStore(), lang: .constant("en"))
//}
