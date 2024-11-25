//
//  WebillConnectView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/18/24.
//

import SwiftUI
import SwiftData
import Combine
struct WebillConnectView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @StateObject private var webillConnect = WeBill365ViewModel()
  
    @State private var showMessage = false
    @State private var clientIDError: String? = nil
    @State private var secretIDError: String? = nil
    @State private var accountNumberError: String? = nil
    @State private var isClearingAccount = false
    var body: some View {
        NavigationStack {
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
                                .opacity(0.7)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        ClientIdTextField(
                            iconName: "lock",
                            placeholder: "Enter your Client ID",
                            text: $webillConnect.clientID,
                            isSecure: false
                        )
                        .onChange(of: webillConnect.clientID) { newValue in
                            if !newValue.isEmpty {
                                clientIDError = nil
                            }
                        }
                        if let error = clientIDError {
                            Text(error)
                                .font(.customfont(.regular, fontSize: 12))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 5)
                        }
                    }

                    // Secret ID Field
                    Group {
                        HStack {
                            Text("Secret ID")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundStyle(Color(hex: "#0A0019"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.7)
                        }
                        PasswordField(
                            iconName: "lock",
                            placeholder: "Enter your Secret ID",
                            text: $webillConnect.clientSecret,
                            isSecure: true,
                            frameWidth: UIScreen.main.bounds.width * 0.9
                        )
                        .onChange(of: webillConnect.clientSecret) { newValue in
                            if !newValue.isEmpty {
                                secretIDError = nil
                            }
                        }
                        if let error = secretIDError {
                            Text(error)
                                .font(.customfont(.regular, fontSize: 12))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 5)
                        }
                    }

                    // Account Number Field
                    Group {
                        HStack {
                            Text("Account Number")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundStyle(Color(hex: "#0A0019"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.7)
                        }
                        PasswordField(
                            iconName: "lock",
                            placeholder: "Enter Account Number",
                            text: $webillConnect.parentAccountNo,
                            isSecure: true,
                            frameWidth: UIScreen.main.bounds.width * 0.9
                        )
                        .onChange(of: webillConnect.parentAccountNo) { newValue in
                            if !newValue.isEmpty {
                                accountNumberError = nil
                            }
                        }
                        if let error = accountNumberError {
                            Text(error)
                                .font(.customfont(.regular, fontSize: 12))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 5)
                        }
                    }

                    Spacer()

                    // Save Button
                    CustomButton(
                        title: "Save",
                        action: {
                            validateAndSubmit()
                        },
                        backgroundColor: PrimaryColor.normal,
                        frameHeight: 55,
                        frameWidth: UIScreen.main.bounds.width * 0.9
                    )
                }
                .ignoresSafeArea(.keyboard)
                .navigationBarHidden(true)
                .padding(.horizontal, 20)
                .onAppear {
                    webillConnect.loadWeBillAccount(context: context)
                }

                // Loading Indicator
                if webillConnect.isLoading {
                    LoadingViewForWebill()
                }

                // Success Popup
                if showMessage {
                    SuccessMessageForWeBill(imageName: "SuccessCheck", message: isClearingAccount ? "WeBill365 account deleted successfully." : "WeBill365 account connected successfully.", color: .green)
                        .transition(.opacity)
                }

                // Error Alert
                if webillConnect.showError {
                    SuccessMessageForWeBill(imageName: "delete 1", message: "WeBill365 account could not be connected.", color: .red)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    webillConnect.showError = false
                                }
                            }
                        }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    // MARK: - Validation Logic
     func validateAndSubmit() {
        // Reset errors
        clientIDError = nil
        secretIDError = nil
        accountNumberError = nil

        // Check if all fields are empty
        let areFieldsEmpty = webillConnect.clientID.isEmpty &&
                             webillConnect.clientSecret.isEmpty &&
                             webillConnect.parentAccountNo.isEmpty

        if areFieldsEmpty {
            // Call clearWeBillAccount if all fields are empty
            isClearingAccount = true // Mark that we are clearing the account
            webillConnect.clearWeBillAccount(context: context)
            showMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showMessage = false
                dismiss()
            }
            return
        }

        // Perform validation for individual fields
        var hasError = false

        if webillConnect.clientID.isEmpty {
            clientIDError = "Client ID cannot be empty."
            hasError = true
        }

        if webillConnect.clientSecret.isEmpty {
            secretIDError = "Secret ID cannot be empty."
            hasError = true
        }

        if webillConnect.parentAccountNo.isEmpty {
            accountNumberError = "Account Number cannot be empty."
            hasError = true
        }

        // If no errors, proceed with API call
        if !hasError {
            isClearingAccount = false // Mark that we are not clearing the account
            webillConnect.fetchWeBillAccessToken(context: context) { success in
                if success {
                    showMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showMessage = false
                        dismiss()
                    }
                }
            }
        }
    }
  
    
}


//MARK: Loading View
struct LoadingViewForWebill: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                .scaleEffect(2)
                .offset(y: -50)
        }
    }
}
//MARK: Message Success
struct SuccessMessageForWeBill :View {
    var imageName:String
    var message: String
    var color:Color
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center
                    )
                Text(LocalizedStringKey("Successfully"))
                    .font(.customfont(.bold, fontSize: 20))
                    .foregroundStyle(color)
                Spacer().frame(height: 10)
                Text(LocalizedStringKey(message))
                    .font(.customfont(.regular, fontSize: 15))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .screenWidth * 0.65,maxHeight: 150)
            .padding(.horizontal,30)
            .background(.white)
            .cornerRadius(24)
        }
    }
}

// MARK: - Alert View
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
