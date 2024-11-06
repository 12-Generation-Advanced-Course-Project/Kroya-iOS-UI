import SwiftUI

struct MainScreen: View {
    @State private var selectedTab = 1
    @State var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isModalPresented: Bool = false
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
    @StateObject private var authVM: AuthViewModel
    @StateObject private var addressViewModel: AddressViewModel
    @StateObject private var profileVM: ProfileViewModel
    @StateObject private var draftModelData: DraftModelData
    @Environment(\.modelContext) var modelContext
    @Binding var lang: String
    
    init(userStore: UserStore, lang: Binding<String>) {
        _authVM = StateObject(wrappedValue: AuthViewModel(userStore: userStore))
        _addressViewModel = StateObject(wrappedValue: AddressViewModel(userStore: userStore))
        _profileVM = StateObject(wrappedValue: ProfileViewModel(userStore: userStore))
        _draftModelData = StateObject(wrappedValue: DraftModelData(userStore: userStore))
        self._lang = lang
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 10) {
                    TabView(selection: $selectedTab) {
                        HomeView()
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
                        PostViewScreen(Profile: profileVM)
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

                        ProfileView(authVM: authVM, Profile: profileVM, lang: $lang)
                            .environmentObject(addressViewModel)
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
                            isModalPresented.toggle()
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
            }
            .frame(width: .screenWidth, height: .screenHeight)
        }
        .onAppear {
            profileVM.fetchUserProfile()
            addressViewModel.fetchAllAddresses()
            draftModelData.loadDraft(from: modelContext)
           
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isModalPresented) {
            AddFoodView(
                rootIsActive1: $isActive,
                dismissToRoot: { isModalPresented = false },
                addressVM: addressViewModel,
                draftModelData: draftModelData, addNewFoodVM: addNewFoodVM
            )
            .environment(\.modelContext, modelContext)
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
