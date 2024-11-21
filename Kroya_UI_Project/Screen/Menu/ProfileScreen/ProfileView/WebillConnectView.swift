//
//  WebillConnectView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/18/24.
//

import SwiftUI
import SwiftData

struct WebillConnectView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @StateObject private var webillConnect = WeBill365ViewModel()
    @State private var showMessage = false

    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                // Navigation Bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }

                // Title
                Image("webill365_logo")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 119, height: 20)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Description
                HStack {
                    Text("Connect to WeBill365 account for e-payment")
                        .font(.customfont(.medium, fontSize: 15))
                        .padding([.bottom, .top], 5)
                        .foregroundStyle(Color(hex: "#737A86"))
                    Spacer()
                }

                // Client ID Field
                Group {
                    HStack {
                        Text("Client ID")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundStyle(Color(hex: "#0A0019"))
                            .padding(.top, 15)
                            .opacity(0.7)
                        Spacer()
                    }
                    ClientIdTextField(
                        iconName: "lock",
                        placeholder: "Enter your Client ID",
                        text: $webillConnect.clientID,
                        isSecure: false
                    )
                }

                // Secret ID Field
                Group {
                    HStack {
                        Text("Secret ID")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundStyle(Color(hex: "#0A0019"))
                            .padding(.top, 10)
                            .opacity(0.7)
                        Spacer()
                    }
                    PasswordField(
                        iconName: "lock",
                        placeholder: "Enter your Secret ID",
                        text: $webillConnect.clientSecret,
                        isSecure: true,
                        frameWidth: UIScreen.main.bounds.width * 0.9
                    )
                }

                // Account Number Field (if needed)
                //If you had an account number field in your old UI, include it here
                Group {
                    HStack {
                        Text("Account Number")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundStyle(Color(hex: "#0A0019"))
                            .padding(.top, 10)
                            .opacity(0.7)
                        Spacer()
                    }
                    PasswordField(
                        iconName: "lock",
                        placeholder: "Enter Account Number",
                        text: $webillConnect.accountNumber,
                        isSecure: true,
                        frameWidth: UIScreen.main.bounds.width * 0.9
                    )
                }
                Spacer()
                // Save Button
                CustomButton(
                    title: "Save",
                    action: {
                        webillConnect.fetchWeBillAccessToken(context: context) { success in
                            if success {
                                showMessage = true
                                // Dismiss the message after 0.8 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    showMessage = false
                                    dismiss()
                                }
                            }
                        }
                    },
                    backgroundColor: PrimaryColor.normal,
                    frameHeight: 55,
                    frameWidth: UIScreen.main.bounds.width * 0.9
                )
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 20)
            .onAppear {
                webillConnect.loadWeBillAccount(context: context)
                if webillConnect.clientID.isEmpty || webillConnect.clientSecret.isEmpty {
                  
                }
            }


            // Loading Indicator
            if webillConnect.isLoading {
                LoadingView()
            }

            // Success Popup
            if showMessage {
                SuccessPopup()
                    .transition(.scale)
            }

            // Error Alert
            if webillConnect.showError {
                AlertView(
                    title: "Error",
                    message: webillConnect.errorMessage,
                    onDismiss: {
                        webillConnect.showError = false
                    }
                )
                .transition(.scale)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    WebillConnectView()
}

// Existing AlertView remains the same
struct AlertView: View {
    var title: String
    var message: String
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Button(action: onDismiss) {
                Text("OK")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.red)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.horizontal, 40)
    }
}
