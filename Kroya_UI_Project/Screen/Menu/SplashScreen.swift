

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @StateObject private var userStore = UserStore()
    @EnvironmentObject var auth: Auth
    @Binding var lang: String
    var body: some View {
        NavigationView {
            if isActive {
                if  auth.getAccessToken() != nil {
                    //MARK: Token found in Keychaien, navigate to MainScreen
                    
                    MainScreen(lang: $lang)
                        .environmentObject(userStore)
                        .onAppear {
                            print("Token found in Keychain, navigating to MainScreen.")
                        }
                }
                else {
                    //MARK: No token found, navigate to LoginScreen
                    LoginScreenView(userStore: userStore,lang: $lang)
                        .environmentObject(userStore)
                        .onAppear {
                            print("No access token found, navigating to LoginScreen.\(String(describing: userStore.user?.email))")
                        }
                }
            } else {
                ZStack {
                    Color(.yellow).edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("KroyaWhiteLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
