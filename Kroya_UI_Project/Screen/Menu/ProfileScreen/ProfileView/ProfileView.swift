



import SwiftUI
import Kingfisher
import SDWebImageSwiftUI
struct ProfileView: View {
    @StateObject private var WeBillVM = WeBill365ViewModel()
    @State private var showingCredits = false
    @State private var selectedLanguage: String? = nil
    @State private var isLogout = false
    @State private var isLoading = false
    @State private var showLogoutSuccessAlert = false
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedAddress: Address?
    @EnvironmentObject var userStore: UserStore
    @State private var showMapSheet = false
    @StateObject private  var Profile =  ProfileViewModel()
    @State private var isgotoBill = false
    @State private var isEdit: Bool = false
    @State private var addressToUpdate: Address? = nil
    var urlImagePrefix: String = Constants.fileupload
    @Environment(\.modelContext) var modelContext
    @Binding var lang: String
    @State private var showAlertWeBill = false
    @State private var isUpdatingLocation = false // Add this state to track loading
    @StateObject private var keyboardResponder = KeyboardResponder()
    init(lang: Binding<String>) {
        self._lang = lang
    }
    @State private var isConnect:String = "Connect with"
    var body: some View {
        ZStack {
            ScrollView(.vertical,showsIndicators: false){
                VStack {
                    HStack {
                        HStack {
                            if let profileImageUrl = Profile.userProfile?.profileImage, !profileImageUrl.isEmpty {
                                WebImage(url:URL(string: "\(urlImagePrefix)\(profileImageUrl)"))
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
                                Text(Profile.userProfile?.fullName ?? "")
                                    .customFontBoldLocalize(size: 16)
                                    .foregroundStyle(.black)
                                Spacer().frame(height: 5)
                                Text("\(Profile.formatDate(from: Profile.userProfile?.createdAt ?? ""))")
                                    .customFontLightLocalize(size: 12)
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                        
                        // Edit button
                        Text("Edit")
                            .customFontSemiBoldLocalize(size: 16)
                            .foregroundStyle(PrimaryColor.normal)
                            .onTapGesture {
                                isEdit.toggle()
                            }
                        
                        //                    NavigationLink(
                        //                        destination: EditingProfileView(
                        //                            profile: Profile,
                        //                            authVM: authVM,
                        //                            selectedAddress: $selectedAddress
                        //                        ).environmentObject(userStore)
                        //                                   ,isActive: $isEdit) {
                        //                        EmptyView()
                        //                    }.hidden()
                        
                        NavigationLink(
                            destination: EditingProfileView(
                                profile: Profile,
                                selectedAddress: $selectedAddress
                            )
                            .environmentObject(userStore),
                            isActive: $isEdit
                        ) {
                            EmptyView()
                        }.hidden()
                        
                        
                        
                    }
                    .padding(.horizontal, 10)
                    
                    
                    Spacer().frame(height: .screenHeight * 0.04)
                    HStack {
                        NavigationLink(destination: FavoriteViewCart()) {
                            UserInfoCardView(
                                title: "Favorite",
                                subtitle: "List of their favorite dishes",
                                width: .screenWidth * 0.44,
                                height: .screenHeight * 0.11,
                                isTextCenter: false
                            )
                        }
                        NavigationLink(destination: AddressView(isFromEditingProfileView: false)) {
                            UserInfoCardView(
                                title: "Addresses",
                                subtitle: "List of your addresses",
                                width: .screenWidth * 0.44,
                                height: .screenHeight * 0.11,
                                isTextCenter: false
                            )
                        }
                    }
                    HStack {
                        NavigationLink(destination: SaleReportView()) {
                            UserInfoCardView(
                                title: "Sale Reports",
                                subtitle: "View all sales",
                                width: .screenWidth * 0.9,
                                height: .screenHeight * 0.11,
                                isTextCenter: true
                            )
                        }
                    }
                    Spacer().frame(height: .screenHeight * 0.03)
                    // WeBill connection status
                    NavigationLink(
                        destination: WebillConnectView(webillConnect: WeBillVM, isConnect: $isConnect).environment(\.modelContext, modelContext)
                    ) {
                        VStack(alignment: .leading) {
                            Text("Payment Method")
                                .customFontMediumLocalize(size: 14)
                                .foregroundStyle(.black)
                            Spacer().frame(height: .screenHeight * 0.02)
                            HStack(spacing: 10) {
                                Image("ico_link")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                
                                // Dynamic text based on connection status
                                Text(WeBillVM.Connected)
                                    .customFontMediumLocalize(size: 16)
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                                
                                Text("weBill365")
                                    .customFontMediumLocalize(size: 14)
                                    .foregroundStyle(.black.opacity(0.75))
                                Image("Rightarrow")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            .frame(maxWidth: .screenWidth * 0.9, minHeight: .screenHeight * 0.05)
                            .padding(.horizontal)
                            .background(Color(hex: "#F4F5F7"))
                            .cornerRadius(15)
                        }
                    }
                    
                    Spacer().frame(height: .screenHeight * 0.03)
                    VStack(alignment: .leading) {
                        Text("App Settings")
                            .customFontMediumLocalize(size: 14)
                        Spacer().frame(height: .screenHeight * 0.02)
                        AppSettingView(imageName: "VectorLocation", title: LocalizedStringKey("Change location"), iconName: "Rightarrow")
                            .onTapGesture {
                                showMapSheet.toggle()
                            }
                            .sheet(isPresented: Binding<Bool>(
                                get: { showMapSheet || isUpdatingLocation }, // Keep the sheet open while loading
                                set: { newValue in
                                    if !isUpdatingLocation { showMapSheet = newValue } // Allow dismiss only if not loading
                                }
                            )) {
                                ZStack {
                                    NavigationStack {
                                        AddressView(
                                            onAddressSelected: { selected in
                                                // Handle selected address
                                                selectedAddress = selected
                                                
                                                // Start showing the loading indicator
                                                isUpdatingLocation = true
                                                
                                                // Simulate location update with a delay for testing
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                    Profile.updateLocation(location: selected.addressDetail) { success in
                                                        isUpdatingLocation = false
                                                        if success {
                                                            print("Location updated successfully.")
                                                            showMapSheet = false // Close the sheet after loading
                                                        } else {
                                                            print("Failed to update location.")
                                                        }
                                                    }
                                                }
                                            },
                                            isFromEditingProfileView: true
                                        )
                                    }
                                    
                                    // Loading indicator overlay
                                    if isUpdatingLocation {
                                        ZStack {
                                            Color.black.opacity(0.4)
                                                .ignoresSafeArea()
                                            ProgressView("Updating location...")
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                        
                        NavigationLink {
                            AllowNotificationView()
                        } label: {
                            AppSettingView(imageName: "notification 1", title: LocalizedStringKey("Notifications"), iconName: "Rightarrow")
                        }.accentColor(.black)
                        
                        Button {
                            showingCredits.toggle()
                        } label: {
                            AppSettingView(imageName: "languageIcon", title: LocalizedStringKey("Language"), iconName: "Rightarrow")
                        }
                        .sheet(isPresented: $showingCredits) {
                            ChangeLanguageView(lang: $lang)
                        }
                        .accentColor(.black)
                    }
                    Spacer().frame(height: .screenHeight * 0.04)
                    
                    // Logout Button
                    CustomButton(title: LocalizedStringKey("Log out"), action: {
                        isLoading = true
                        authVM.logoutApp()
                        WeBillVM.clearWeBillAccount(context: modelContext)
                    }, backgroundColor: .red, frameWidth: .screenWidth * 0.95)
                    
                    
                    // NavigationLink to go to LoginScreenView on logout
                    NavigationLink(destination: LoginScreenView(userStore: _userStore,lang: $lang), isActive: $authVM.islogout) {
                        EmptyView()
                    }.hidden()
                    
                    Spacer()
                }
                .ignoresSafeArea(.keyboard)
                .fullScreenCover(isPresented: $showMapSheet, content: {
                    //MapSelectionView(viewModel: addressVM, showMapSheet: $showMapSheet,addressToUpdate: addressToUpdate)
                })
                .padding(.horizontal, 10)
            }
            
            .simultaneousGesture(
                TapGesture().onEnded {
                    hideKeyboard()
                }
            )
            .padding(.bottom, min(keyboardResponder.currentHeight, 0))
            if isLoading {
                ProgressIndicator()
            }
            if showAlertWeBill {
                WeBillDisconnect(
                    onCancel: { showAlertWeBill = false },
                    onYes: {
                        isLoading = true
                        showAlertWeBill = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            //                            showLoadingOverlay = false
                            WeBillVM.DisconnectWeBillaccount(context: modelContext)
                        }
                    }
                )
            }
        }
        .onAppear {
            Profile.fetchUserProfile()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                WeBillVM.fetchWeBillAccount(SellerId: Profile.userProfile?.id ?? 0)
            })
           
            //            addressVM.fetchAllAddresses()
            //            selectedAddress = addressVM.selectedAddress
        }
        .refreshable {
            Profile.fetchUserProfile()
            //            addressVM.fetchAllAddresses()
        }
        
    }
    
}
