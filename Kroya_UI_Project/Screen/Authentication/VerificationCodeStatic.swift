import SwiftUI

struct VerificationCodeStatic: View {
    @Environment(\.dismiss) var dismiss
    @State private var code: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @StateObject private var countdownTimer = CountdownTimer()
    @State private var showError = false
    @State private var isOTPVerified = false
    @State private var isLoading = false
    @State private var sampleEmail = "example@gmail.com" // Hardcoded email for static view
    @Binding var lang: String // Language binding to toggle text based on language
    
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
                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.3)
                            .offset(x: -5)
                        Image("food_recipe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.55, height: UIScreen.main.bounds.height * 0.45)
                            .offset(x: 20)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)

                    // Text and instruction
                    VStack(alignment: .leading) {
                        Text(lang == "en" ? "Verification Code" : "លេខកូដបញ្ជាក់")
                            .font(.customfont(.semibold, fontSize: 20))
                            .foregroundColor(.black)
                        Spacer().frame(height: 10)
                        Text(lang == "en" ? "Enter the 6-digit code sent to your email" : "បញ្ចូលលេខកូដ ៦ ខ្ទង់ដែលបានផ្ញើរទៅអ៊ីម៉ែលរបស់អ្នក")
                            .font(.customfont(.light, fontSize: 13))
                            .foregroundColor(Color(hex: "#777F89"))
                        Spacer().frame(height: 5)
                        Text(sampleEmail) // Static email
                            .font(.customfont(.medium, fontSize: 13))
                            .foregroundColor(Color(hex: "#777F89"))
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)

                    // 6-digit code input fields with numeric filtering
                    OTPTextField(numberOfFields: 6, code: $code)
                        .onChange(of: code) { _ in
                            filterNumericInput()
                        }
                        .offset(x: 25)

                    Spacer().frame(height: 15)

                    // Resend Code Button with Countdown
                    HStack {
                        if showError {
                            Image(systemName: "exclamationmark.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.red)
                                .frame(width: 12, height: 12)
                            Text(lang == "en" ? "Invalid OTP Code, please try again." : "លេខកូដ OTP មិនត្រឹមត្រូវ សូមព្យាយាមម្តងទៀត។")
                                .font(.customfont(.regular, fontSize: 11))
                                .foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)

                    Spacer().frame(height: 15)

                    HStack {
                        Button(action: {
                            countdownTimer.start()
                        }) {
                            Text(lang == "en" ? "Resend Code" : "ផ្ញើលេខកូដម្តងទៀត")
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
                    isLoading = true
                    verifyOTPCode(otpCode)
                }) {
                    Text(lang == "en" ? "Next" : "បន្ទាប់")
                        .font(.customfont(.semibold, fontSize: 18))
                        .frame(width: UIScreen.main.bounds.width * 0.85)
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

            NavigationLink(destination: CreatePasswordStatic(lang: $lang), isActive: $isOTPVerified) {
                EmptyView()
            }
            .hidden()

            if isLoading {
                ProgressIndicator()
            }
        }
        .navigationBarHidden(true)
    }

    // Static OTP verification function
    private func verifyOTPCode(_ otpCode: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate a loading delay
            let isNumeric = otpCode.allSatisfy { $0.isNumber } // Check if all characters are numbers
            if isNumeric && otpCode.count == 6 { // Ensure it's 6 digits
                isOTPVerified = true
                showError = false
            } else {
                isOTPVerified = false
                showError = true
            }
            isLoading = false // Stop loading indicator after validation
        }
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
