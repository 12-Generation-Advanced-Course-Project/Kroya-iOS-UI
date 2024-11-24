



import SwiftUI

struct LoginScreenView: View {
    @State private var email: String = ""
    @State private var isEmailInvalid: Bool = false
    @State private var showingCredits = false
    @Environment(\.locale) var local
    @StateObject private var countdownTimer = CountdownTimer()
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var authVM: AuthViewModel
    @Binding var lang:String
//    @StateObject private var authVM: AuthViewModel
//    @EnvironmentObject var userStore: UserStore
    @State private var showLoadingOverlay = false
    @State private var navigateToDestination = false
//    init(userStore: UserStore, lang: Binding<String>) {
//        _authVM = StateObject(wrappedValue: AuthViewModel(userStore: userStore))
//        self._lang = lang
//    }
    
//    init(userStore: UserStore, lang: Binding<String>) {
//        self.authVM = AuthViewModel(userStore: userStore) // Initialize AuthViewModel here
//        self._lang = lang
//    }

    
    
    var body: some View {
        NavigationStack{
            
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        Image("image background")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 260)
                        
                            .overlay(alignment: .topTrailing){
                                Button(action:{
                                    showingCredits = true
                                }){
                                    if local.identifier == "km-KH" {
                                        Image("Khmer")
                                    }else if local.identifier == "en"{
                                        Image("English")
                                    }
                                    else{
                                        Image("Korean")
                                    }
                                }
                                .padding()
                                .sheet(isPresented: $showingCredits) {
                                    ChangeLanguageView(lang: $lang)
                                }
                                
                            }
                        
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
                        .keyboardType(.emailAddress)
                        .onChange(of: email, perform: { newValue in
                            validateEmail(email: newValue) // Call validation function on email change
                        })
                        
                        if isEmailInvalid {
                            HStack{
                                Image(systemName: "exclamationmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.red)
                                    .frame(width: 12, height: 10)
                                Text(LocalizedStringKey("Please enter a valid email address."))
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                    .padding(.top, -70)
                    
                    Button(action: {
                        navigateToDestination = false // Reset navigation state
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
                        isActive: $navigateToDestination //** Updated to use `navigateToDestination`
                    ) {
                        EmptyView()
                    }
                    .hidden()
                    
//                    NavigationLink(
//                        destination: destinationView(),
//                        isActive: Binding(
//                            get: { authVM.isOTPSent || authVM.isEmailExist },
//                            set: { _ in }
//                        ),
//                        label: {
//                            EmptyView()
//                        }
//                    )
//                    .hidden()
                    
                    // Guest Login Button
                    Button(action: {
                        // Guest login action without token
                        Auth.shared.loggedIn = true
                        showLoadingOverlay = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showLoadingOverlay = false
                            navigateToMainScreen()
                        }
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
                }
                .navigationBarHidden(true)
                
                // Show Progress Indicator while loading
                if authVM.isLoading {
                    ProgressIndicator()
                }
                
                if showLoadingOverlay == true {
                    LoadingOverlay()
                }
            }
            .onChange(of: authVM.isOTPSent || authVM.isEmailExist) { newValue in
                print("onChange triggered: \(newValue)")
                print("isOTPSent: \(authVM.isOTPSent), isEmailExist: \(authVM.isEmailExist)")
                navigateToDestination = newValue
            }
//            .onChange(of: authVM.isOTPSent || authVM.isEmailExist) { newValue in
//                if newValue {
//                    navigateToDestination = true
//                }
//            }

        }
        .onAppear {
//            Auth.shared.loggedIn = false // Ensure loggedIn is false
//            navigateToDestination = false // Reset navigation state
            // Do not reset authVM.isEmailExist or authVM.isOTPSent here
            authVM.isLoggedIn = false
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
            VerificationCodeView(authVM: authVM, lang: $lang).environmentObject(userStore)
        } else if authVM.isEmailExist {
//            FillPasswordScreen(authVM: authVM, email: email, lang: $lang).environmentObject(userStore)
            FillPasswordScreen(email: email, lang: $lang).environmentObject(userStore)
        } else {
            EmptyView()
        }
    }


    func navigateToMainScreen() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootWindow = windowScene.windows.first {
            rootWindow.rootViewController = UIHostingController(
//                rootView: MainScreen(userStore: userStore, lang: $lang)
                rootView: MainScreen(lang: $lang)
                    .environmentObject(userStore)
                    .environmentObject(authVM)
//                    .environmentObject(Auth.shared)
//                    .environmentObject(addressViewModel)
            )
            rootWindow.makeKeyAndVisible()
        }
    }

}
