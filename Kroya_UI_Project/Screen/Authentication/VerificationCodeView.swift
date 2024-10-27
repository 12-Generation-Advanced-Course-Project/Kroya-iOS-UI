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
    @ObservedObject var authVM: AuthViewModel
    @Binding var lang: String

    var body: some View {
        NavigationView {
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
                                Text("Unable to fetch user information.")
                                    .font(.customfont(.medium, fontSize: 13))
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        
                        // 6-digit code input fields
                        OTPTextField(numberOfFields: 6, code: $code)
                            .onChange(of: code) { _ in
                                filterNumericInput()
                            }
                            .offset(x: 25)
                        
                        Spacer().frame(height: 15)
                        // Resend Code Button with Countdown
                        HStack{
                           
                            if authVM.showError {
                                Image(systemName: "exclamationmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.red)
                                    .frame(width: 12,height: 12)
                                Text("Invalid OTP Code, please try again.")
                                    .font(.customfont(.regular, fontSize: 11))
                                    .foregroundStyle(.red)
                                
                                    
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                         .padding(.horizontal,15)
                        Spacer().frame(height: 15)
                        HStack {
                            Button(action: {
                                authVM.sendOTP(email: userStore.user?.email ?? "") { success in
                                    if success {
                                        countdownTimer.start()
                                    } else {
                                        print("Failed to resend OTP.")
                                    }
                                }
                            }) {
                                Text("Resend Code")
                                    .font(.customfont(.semibold, fontSize: 14))
                                    .foregroundColor(.gray)
                            }
                            .disabled(countdownTimer.isResendDisabled)
                            if countdownTimer.isResendDisabled {
                                Text(countdownTimer.formattedCountdown)
                                    .font(.customfont(.semibold, fontSize: 12))
                                    .foregroundColor(.green)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onAppear {
                            countdownTimer.start()
                            focusedField = 0
                        }
                    }
                    .padding(.horizontal, 115)
                    .padding(.top, 20)

                    Spacer().frame(height: 15)
                    
                   
                    
                    // Next Button for OTP submission
                    Button(action: {
                        let otpCode = code.joined() // Combine the 6 digits into a single string
                        print("Sending OTP: \(otpCode)")
                        authVM.verifyOTPcode(userStore.user?.email ?? "", otpCode) {
                            authVM.isOTPVerified = false
                        }
                    }) {
                        Text("Next")
                            .font(.customfont(.semibold, fontSize: 18))
                            .frame(width: .screenWidth * 0.85)
                            .padding()
                            .background(isCodeComplete ? Color.yellow : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .disabled(!isCodeComplete)
                    .padding(.top, 15)
                    Spacer()
                }
                
                NavigationLink(destination: CreatePasswordView(authVM: authVM, lang: $lang).environmentObject(userStore), isActive: $authVM.isOTPVerified) {
                    EmptyView()
                }
                .hidden()

                if authVM.isLoading {
                    ProgressIndicator()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // Filter input to allow only numbers
    private func filterNumericInput() {
        for i in 0..<code.count {
            code[i] = code[i].filter { $0.isNumber }
        }
    }
    
    // Computed property to check if all fields are filled
    private var isCodeComplete: Bool {
        return code.allSatisfy { !$0.isEmpty && $0.count == 1 }
    }
}
