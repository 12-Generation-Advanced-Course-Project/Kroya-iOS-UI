



import SwiftUI

struct ProfileView: View {
    @State private var showingCredits = false
    @State private var selectedLanguage: String? = nil
    @State private var isLogout = false
    @State private var isLoading = false
    @EnvironmentObject var userStore: UserStore
    @State private var showLogoutSuccessAlert = false
    @ObservedObject var authVM = AuthViewModel(userStore: UserStore())
    @Binding var lang: String
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer().frame(height: .screenHeight * 0.04)
                    HStack {
                        NavigationLink(destination: FavoriteViewCart()) {
                            UserInfoCardView(
                                title: LocalizedStringKey("Favorite"),
                                subtitle: LocalizedStringKey("List of their favorite dishes"),
                                width: .screenWidth * 0.44,
                                height: .screenHeight * 0.11,
                                isTextCenter: false
                            )
                        }
                        UserInfoCardView(
                            title: "Addresses",
                            subtitle: "List of your addresses",
                            width: .screenWidth * 0.44,
                            height: .screenHeight * 0.11,
                            isTextCenter: false
                        )
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
                    NavigationLink(destination: WebillConnectView()) {
                        VStack(alignment: .leading) {
                            Text("Payment Method")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundStyle(.black)
                            Spacer().frame(height: .screenHeight * 0.02)
                            HStack(spacing: 10) {
                                Image("ico_link")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                Text("Connected")
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Text("weBill365")
                                    .font(.customfont(.medium, fontSize: 16))
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
                            .font(.customfont(.medium, fontSize: 14))
                        Spacer().frame(height: .screenHeight * 0.02)
                        AppSettingView(imageName: "VectorLocation", title: LocalizedStringKey("Change location"), iconName: "Rightarrow")
                        
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
                    CustomButton(title: "Log out", action: {
                        isLoading = true  // Start showing the loading indicator
                        authVM.logout()
                        
                        // Delay navigation to show progress for 1 second
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false  // Stop showing the loading indicator
                            isLogout = true   // This will trigger navigation to LoginScreen after progress is shown
                            showLogoutSuccessAlert = true
                        }
                    }, backgroundColor: .red, frameWidth: .screenWidth * 0.9)

                    
                    // NavigationLink to go to LoginScreenView on logout
                    NavigationLink(destination: LoginScreenView(userStore: userStore,lang: $lang), isActive: $authVM.islogout) {
                        EmptyView()
                    }.hidden()
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                .toolbar {  // Move toolbar items here so they appear correctly
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Image("Men")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text("Oun Bonaliheng")
                                    .font(.customfont(.bold, fontSize: 16))
                                    .foregroundStyle(.black)
                                Spacer().frame(height: 5)
                                Text("Since Oct, 2024")
                                    .font(.customfont(.light, fontSize: 12))
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: EditingProfileView()) {
                            Text(LocalizedStringKey("Edit"))
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundStyle(PrimaryColor.normal)
                        }
                    }
                }
                
                // Show Circular Progress Indicator while logging out
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                        }
                    }
                }
            }
            .alert(isPresented: $showLogoutSuccessAlert) {
                Alert(
                    title: Text("Logout Successful"),
                    message: Text("Logout was successful."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

//#Preview {
//    ProfileView()
//}
