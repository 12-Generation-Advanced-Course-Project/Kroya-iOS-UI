



import SwiftUI

struct LoginScreenView: View {
    @State private var email: String = ""
    @EnvironmentObject var userStore: UserStore
    @StateObject private var countdownTimer = CountdownTimer()
  
    @StateObject private var authVM: AuthViewModel

    init(userStore: UserStore) {
        _authVM = StateObject(wrappedValue: AuthViewModel(userStore: userStore))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    Image("food_background")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    .offset(y: 170)
                }
                
                Image("KroyaYellowLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .offset(y: -25)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email")
                        .foregroundStyle(.black.opacity(0.5))
                        .font(.customfont(.regular, fontSize: 14))
                    
                    InputField(
                        iconName: "mail.fill",
                        placeholder: "example@gmail.com",
                        text: $email,
                        frameWidth: .screenWidth * 0.9,
                        colorBorder: .white,
                        isMultiline: false
                    )
                }
                .padding()
                .padding(.top, -70)
                
                Button(action: {
                    authVM.sendOTPIfEmailNotExists(email: "hengheng123@gmail.com")
                }) {
                    Text("GET STARTED")
                        .font(.customfont(.semibold, fontSize: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 10)
                
                // Navigation Logic based on OTP status
                NavigationLink(
                    destination: destinationView(),
                    isActive: $authVM.isOTPSent,
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
                
                // Handle email existence with additional NavigationLink if needed
                NavigationLink(
                    destination: FillPasswordScreen(authVM:authVM).environmentObject(userStore),
                    isActive: $authVM.isEmailExist, // Navigate when email exists
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
                
                Button(action: {
                    // Guest login action
                }) {
                    Text("Login as guest")
                        .font(.customfont(.bold, fontSize: 12))
                        .foregroundColor(.black.opacity(0.6))
                }
                .padding(.top, 15)
                
                Spacer()
                VStack(spacing: 2) {
                    Text("By clicking “ GET STARTED ” you agreed to our")
                        .font(.customfont(.regular, fontSize: 12))
                    
                    HStack {
                        Button(action: {
                            // Terms of Service action
                        }) {
                            Text("Terms of Service")
                                .underline()
                                .foregroundColor(.green)
                        }
                        
                        Text("and")
                        
                        Button(action: {
                            // Privacy action
                        }) {
                            Text("Privacy")
                                .underline()
                                .foregroundColor(.green)
                        }
                    }
                }
                .font(.customfont(.regular, fontSize: 12))
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        
            // Show Progress Indicator while loading
            if authVM.isLoading {
                ProgressIndicator()
            }
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if authVM.isOTPSent {
            VerificationCodeView(authVM: authVM).environmentObject(userStore)
        } else {
            EmptyView()
        }
    }
}
