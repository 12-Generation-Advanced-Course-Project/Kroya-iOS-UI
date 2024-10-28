



import SwiftUI

struct LoginScreenView: View {
    @State private var email: String = ""
    @State private var isEmailInvalid: Bool = false
   
    @StateObject private var countdownTimer = CountdownTimer()
    
    @StateObject private var authVM: AuthViewModel
    @EnvironmentObject var userStore: UserStore
    init(userStore: UserStore) {
        _authVM = StateObject(wrappedValue: AuthViewModel(userStore: userStore))
    }
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        Image("image background")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 260)
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
                        .onChange(of: email, perform: { newValue in
                            validateEmail(email: newValue) // Call validation function on email change
                        })
                        
                        if isEmailInvalid {
                            Text("Please enter a valid email address.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .padding(.top, -70)
                    
                    Button(action: {
                        authVM.sendOTPIfEmailNotExists(email: email)
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
                    .disabled(isEmailInvalid || email.isEmpty)
                    NavigationLink(
                        destination: destinationView(),
                        isActive: Binding(
                            get: { authVM.isOTPSent || authVM.isEmailExist },
                            set: { _ in }
                        ),
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
                    
                    // Terms and Privacy Policy Text
                    VStack(spacing: 2) {
                        Text("By clicking “ GET STARTED ” you agreed to our")
                            .font(.customfont(.regular, fontSize: 12))
                        
                        HStack {
                            Button(action: {
                                // Terms of Service action
                            }) {
                                Text("Terms of Service")
                                    .underline()
                                    .foregroundColor(PrimaryColor.normal)
                            }
                            
                            Text("and")
                            
                            Button(action: {
                                // Privacy action
                            }) {
                                Text("Privacy")
                                    .underline()
                                    .foregroundColor(PrimaryColor.normal)
                            }
                        }
                    }
                    .font(.customfont(.regular, fontSize: 12))
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
                .navigationBarHidden(true)
                
                // Show Progress Indicator while loading
                if authVM.isLoading {
                    ProgressIndicator()
                }
            }
        }
    }
    
    // Validation function to check email format
    private func validateEmail(email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        isEmailInvalid = !emailPredicate.evaluate(with: email)
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if authVM.isOTPSent {
            // OTP sent, navigate to VerificationCodeView
            VerificationCodeView(authVM: authVM).environmentObject(userStore)
        } else if authVM.isEmailExist {
            // Email exists, navigate to FillPasswordScreen
            FillPasswordScreen(authVM: authVM, email: email).environmentObject(userStore)
        } else {
            EmptyView()
        }
    }
}
