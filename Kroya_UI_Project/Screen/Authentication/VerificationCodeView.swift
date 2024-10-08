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

    var body: some View {
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
                        Text("Enter the 6-digit code sent to your mobile number")
                            .font(.customfont(.light, fontSize: 13))
                            .foregroundColor(Color(hex: "#777F89"))
                        Spacer().frame(height: 5)
                        Text("+85581870107")
                            .font(.customfont(.medium, fontSize: 13))
                            .foregroundColor(Color(hex: "#777F89"))
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    
                    // 6-digit code input fields
                    OTPTextField(numberOfFields: 6)
                        .offset(x: 25)
                    
                    // Resend Code Button with Countdown
                    HStack {
                        Button(action: {
                            countdownTimer.start()
                        }) {
                            Text("Resend Code")
                                .font(.customfont(.semibold, fontSize: 14))
                                .foregroundColor(.gray)
                        }
                        .disabled(countdownTimer.isResendDisabled)
                        .padding(.horizontal, 10)
                        
                        if countdownTimer.isResendDisabled {
                            Text(countdownTimer.formattedCountdown)
                                .font(.customfont(.semibold, fontSize: 12))
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal, 115)
                    .padding(.top, 20)
                }
                .onAppear {
                    focusedField = 0
                }
                
             
                NavigationLink(destination: CreatePasswordView()) {
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
                
                Spacer()
            }
            .navigationBarHidden(true)
        
    }
}

#Preview {
    VerificationCodeView()
}

