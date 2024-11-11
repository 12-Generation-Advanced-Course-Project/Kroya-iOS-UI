
import SwiftUI

struct SplashScreen: View {
    @Binding var isSplashScreenActive: Bool
//    @StateObject private var userStore = UserStore()
    @EnvironmentObject var auth: Auth
    @Binding var lang: String
    @StateObject var userStore = UserStore()
    @StateObject var addressViewModel = AddressViewModel()
    var body: some View {
       
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            VStack {
                Image("KroyaWhiteLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            // Simulate loading delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.isSplashScreenActive = false
                }
            }
        }
        .navigationBarHidden(true)
    }
}
