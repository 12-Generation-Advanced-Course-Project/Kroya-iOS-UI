



import SwiftUI
import Kingfisher
struct ProfileView: View {
    @State private var showingCredits = false
    @State private var selectedLanguage: String? = nil
    @State private var isLogout = false
    @State private var isLoading = false
    @State private var showLogoutSuccessAlert = false
    @ObservedObject  var authVM : AuthViewModel
    @State private var selectedAddress: Address?
    @EnvironmentObject var addressVM: AddressViewModel
    @EnvironmentObject var userStore: UserStore
    @State private var showMapSheet = false
    @ObservedObject  var Profile : ProfileViewModel
    @State private var isgotoBill = false
    @State private var isEdit: Bool = false
    @State private var addressToUpdate: Address? = nil
    var urlImagePrefix: String = "https://kroya-api.up.railway.app/api/v1/fileView/"
    @Binding var lang: String
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    HStack {
                        if let profileImageUrl = Profile.userProfile?.profileImage, !profileImageUrl.isEmpty {
                          
                            KFImage(URL(string: "\(urlImagePrefix)\(profileImageUrl)"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                        } else {
                            Rectangle()
                                .fill(Color(hex: "#D9D9D9"))
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.white)
                                )
                        }
                        
                        VStack(alignment: .leading) {
                            Text(Profile.userProfile?.fullName ?? "")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(.black)
                            Spacer().frame(height: 5)
                            Text("\(Profile.formatDate(from: Profile.userProfile?.createdAt ?? ""))")
                                .font(.customfont(.light, fontSize: 12))
                                .foregroundStyle(.black)
                        }
                    }
                    Spacer()
                    
                    // Edit button
                    Text("Edit")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundStyle(PrimaryColor.normal)
                        .onTapGesture {
                            isEdit.toggle()
                        }
                    
                    NavigationLink(destination: EditingProfileView(profile: Profile,selectedAddress: $selectedAddress, viewModel: addressVM)
                       
                    
                                   ,isActive: $isEdit) {
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
                    NavigationLink(destination: AddressView(viewModel: addressVM)) {
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
                    NavigationLink {
                        MapSelectionView(viewModel: addressVM, showMapSheet: $showMapSheet,addressToUpdate: addressToUpdate)
                    } label: {
                        AppSettingView(imageName: "VectorLocation", title: LocalizedStringKey("Change location"), iconName: "Rightarrow")
                    }.accentColor(.black)
                    
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
                    isLoading = true
                    authVM.logout()
                    
                }, backgroundColor: .red, frameWidth: .screenWidth * 0.95)
                
                
                // NavigationLink to go to LoginScreenView on logout
                NavigationLink(destination: LoginScreenView(userStore: userStore,lang: $lang), isActive: $authVM.islogout) {
                    EmptyView()
                }.hidden()
                
                Spacer()
            }
            .padding(.horizontal, 10)
            if isLoading {
                ProgressIndicator()
            }
        }
        .refreshable {
            Profile.fetchUserProfile()
            addressVM.fetchAllAddresses()
         }
        
    }
    
}

//#Preview {
//    ProfileView()
//}
