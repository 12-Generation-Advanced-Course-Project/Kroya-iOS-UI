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
    @ObservedObject var authVM: AuthViewModel
    @State var email: String
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Header
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
                    
                    // Password Input Section
                    VStack(alignment: .leading) {
                        Text("Password")
                            .foregroundStyle(.black.opacity(0.8))
                            .font(.customfont(.regular, fontSize: 16)) +
                        Text(" *")
                            .foregroundStyle(.red)
                        
                        PasswordField(
                            iconName: "lock",
                            placeholder: "Input your password",
                            text: $password,
                            isSecure: !isPasswordVisible,
                            frameWidth: .infinity
                        )
                        .onChange(of: password) { newValue in
                            validatePassword(newValue) // Validate password on change
                        }
                        
                        HStack{
                            if !isPasswordValid || authVM.showError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.red)
                                        .frame(width: 12, height: 12)
                                    Text(authVM.showError ? "Password is Incorrect" : "Please input a valid password")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .font(.customfont(.regular, fontSize: 12))
                                }
                            }
                            
                            // Forgot Password
                            Button(action: {
                                
                            }) {
                                Text("Forgot Password?")
                                    .foregroundStyle(.black.opacity(0.8))
                                    .font(.customfont(.semibold, fontSize: 12))
                                    .underline()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.top, 5)
                            }
                        }.frame(minHeight: 50,alignment: .top)
                        
                    }
                    .frame(maxWidth: .infinity,minHeight: 200, alignment: .center)
                    .padding(.horizontal,14)
                    
                    
                    Spacer().frame(height: 20)
                    
                    Button(action: {
                        // Validate the password again before login
                        validatePassword(password)
                        
                        // If the password is valid, proceed with login
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
                
                // Navigate to MainScreen on successful login
                NavigationLink(destination: MainScreen().navigationBarBackButtonHidden(true).environmentObject(userStore), isActive: $authVM.isLoggedIn) {
                    EmptyView()
                }
                
                
                // Show Progress Indicator while loading
                if authVM.isLoading {
                    ProgressIndicator()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // Password validation function
    func validatePassword(_ password: String) {
        isPasswordValid = password.count >= 6
    }
}

