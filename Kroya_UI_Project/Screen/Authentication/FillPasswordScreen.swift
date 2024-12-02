//
//  FillPasswordScreen.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 2/10/24.
//

import SwiftUI

struct FillPasswordScreen: View {
    @Environment(\.dismiss) var dismiss
    @State var password: String = ""
    @State var isPasswordVisible: Bool = false
    @State private var isPasswordValid: Bool = true
    @EnvironmentObject var userStore: UserStore
//    @ObservedObject var authVM: AuthViewModel
    @EnvironmentObject var authVM: AuthViewModel // Use EnvironmentObject
    @State var email: String
    @Binding var lang: String
    @State private var isForgetPassword = false
    @Environment(\.locale) var locale
    @StateObject private var keyboardResponder = KeyboardResponder()
    var body: some View {
        ZStack {
            ScrollView(.vertical,showsIndicators: false){
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Continue with password")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Spacer()
                        .frame(width: 24)
                }
                .padding()
                
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .foregroundStyle(.black.opacity(0.8))
                        .font(.customfont(.regular, fontSize: 16)) +
                    Text(" *")
                        .foregroundStyle(.red)
                    
                    PasswordField(
                        iconName: "lock",
                        placeholder: LocalizedStringKey("Input your password"),
                        text: $password,
                        isSecure: !isPasswordVisible,
                        frameWidth: .infinity
                    )
                    .onChange(of: password) { newValue in
                        validatePassword(newValue) // Validate password on change
                    }
                    
                    HStack{
                        if !isPasswordValid || authVM.showError {
                            HStack{
                                Image(systemName: "exclamationmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.red)
                                    .frame(width: 12, height: 10)
                                Text(authVM.showError ? LocalizedStringKey("Password is Incorrect") : LocalizedStringKey("Please input a valid password"))
                                    .frame(width: locale.identifier == "ko" ? 170 : locale.identifier == "km-KH" ? 200 : 170)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .font(.customfont(.regular, fontSize: 10))
                                
                            }
                            .offset(y:-10)
                        }
                        
                        // Forgot Password
                        Button(action: {
                            authVM.sendOTPForReset(email: email){ Success in
                                
                            }
                        }) {
                            Text(LocalizedStringKey("Forget Password?"))
                                .foregroundStyle(.black.opacity(0.8))
                                .font(.customfont(.semibold, fontSize: 12))
                                .underline()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.top, 5)
                        }
                        .frame(minHeight: 50, alignment: .top)


                    }
                    
                }
                .frame(maxWidth: .infinity,minHeight: 200, alignment: .center)
                .padding(.horizontal,14)
                
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    validatePassword(password)
                    if !password.isEmpty && isPasswordValid {
                        authVM.loginAccountEmail(email: email, password: password)
                    }
                }) {
                    Text("Login")
                        .font(.customfont(.semibold, fontSize: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
            .simultaneousGesture(
                TapGesture().onEnded {
                    hideKeyboard()
                }
            )
            .padding(.bottom, min(keyboardResponder.currentHeight, 0))
            
//            // Navigate to MainScreen on successful login
//            NavigationLink(destination: MainScreen(userStore: userStore,lang: $lang).navigationBarBackButtonHidden(true).environmentObject(userStore), isActive: $authVM.isLoggedIn) {
//                EmptyView()
//            }
//            .hidden()
//            if authVM.isLoading {
//                ProgressIndicator()
//            }
//        } .navigationBarHidden(true)
//    }
            // Navigate to MainScreen on successful login
            NavigationLink(
                destination: MainScreen(lang: $lang)
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(userStore)
                    .environmentObject(authVM),
                isActive: $authVM.isLoggedIn
            ) {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(destination: VerificationCodeStatic(emailUser: email, authVM: authVM, lang: $lang), isActive: $authVM.isOTPSendForreset) {
                EmptyView()
            }
            .hidden()
            
            if authVM.isLoading {
                ProgressIndicator()
            }
        }
        .navigationBarHidden(true)
    }
    // Password validation function
    func validatePassword(_ password: String) {
        isPasswordValid = password.count >= 6
    }
}


