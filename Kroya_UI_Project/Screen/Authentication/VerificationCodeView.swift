//
//  VerificationCodeView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 2/10/24.
//

import SwiftUI

struct VerificationCodeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var code: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @StateObject private var countdownTimer = CountdownTimer()
    @EnvironmentObject var userStore: UserStore
    @StateObject private var authVM: AuthViewModel
    
    // Initialize the AuthViewModel in the initializer
    init(userStore: UserStore) {
        _authVM = StateObject(wrappedValue: AuthViewModel(userStore: userStore))
    }
    
    var body: some View {
        ZStack {
            VStack {
                // Back Button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 10)
                
                // Main content (Verification code and other elements)
                VStack(alignment: .leading) {
                    HStack {
                        Image("KroyaYellowLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: .screenWidth * 0.35, height: .screenHeight * 0.3)
                            .offset(x: -5)
                        Image("food_recipe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: .screenWidth * 0.55, height: .screenHeight * 0.45)
                            .offset(x: 20)
                    }
                    .frame(width: .screenWidth, height: .screenHeight * 0.1)
                    
                    // Text and instruction
                    VStack(alignment: .leading) {
                        Text("Verification Code")
                            .font(.customfont(.semibold, fontSize: 20))
                            .foregroundColor(.black)
                        Spacer().frame(height: 10)
                        Text("Enter the 6-digit code sent to your email")
                            .font(.customfont(.light, fontSize: 13))
                            .foregroundColor(Color(hex: "#777F89"))
                        Spacer().frame(height: 5)
                        if let user = userStore.user {
                            Text("\(user.email)")
                                .font(.customfont(.medium, fontSize: 13))
                                .foregroundColor(Color(hex: "#777F89"))
                        } else {
                            Text("No user account!!!")
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    
                    // 6-digit code input fields
                    OTPTextField(numberOfFields: 6, code: $code)
                        .offset(x: 25)
                    
                    Spacer().frame(height: 15)
                    // Resend Code Button with Countdown
                    HStack {
                        Button(action: {
                            // Request to send OTP
                            authVM.sendOTP(email: userStore.user?.email ?? "") { success in
                                if success {
                                    countdownTimer.start()  // Start countdown if OTP is sent successfully
                                } else {
                                    // Handle failure (e.g., show an alert)
                                    print("Failed to resend OTP.")
                                }
                            }
                        }) {
                            Text("Resend Code")
                                .font(.customfont(.semibold, fontSize: 14))
                                .foregroundColor(.gray)
                        }
                        .disabled(countdownTimer.isResendDisabled)  // Disable button based on the timer's state
                        // Show countdown only when it's disabled
                        if countdownTimer.isResendDisabled{
                            Text(countdownTimer.formattedCountdown)
                                .font(.customfont(.semibold, fontSize: 12))
                                .foregroundColor(.green)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onAppear{
                        countdownTimer.start()
                    }


                }
                .padding(.horizontal, 115)
                .padding(.top, 20)
                .onAppear {
                    focusedField = 0
                }
                Spacer().frame(height: 15)
                // Next Button with OTP submission logic
                NavigationLink(destination: CreatePasswordView(), isActive: $authVM.isOTPVerified) {
                    EmptyView()
                }.hidden()
                
                Button(action: {
                    let otpCode = code.joined() // Combine the 6 digits into a single string
                    print("Sending OTP: \(otpCode)") // Debug: Check OTP value
                    authVM.verifyOTPcode(userStore.user?.email ?? "", otpCode)
                }) {
                    Text("Next")
                        .font(.customfont(.semibold, fontSize: 18))
                        .frame(width: .screenWidth * 0.85)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 15)
                .alert(isPresented: $authVM.showError) {
                    Alert(title: Text("Error"), message: Text(authVM.errorMessage), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
            }
            
            // Show Progress Indicator while loading
            if authVM.isLoading {
                ProgressIndicator()
            }
        }
        .navigationBarHidden(true)
    }
}

