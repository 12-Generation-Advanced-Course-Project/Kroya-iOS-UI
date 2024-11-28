//
//  WebillConnectView.swift
//  Kroya_UI_Project
//

import SwiftUI
import SwiftData
import Combine

struct WebillConnectView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @ObservedObject var webillConnect: WeBill365ViewModel
    @StateObject private var keyboardResponder = KeyboardResponder()
    @State private var showMessage = false
    @State private var showError = false
    @State private var isDisconnected = false
    
    @State private var successMessage: String = ""
    @State private var clientIDError: String? = nil
    @State private var secretIDError: String? = nil
    @State private var accountNumberError: String? = nil
    @State private var showDisconnectAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            // Navigation Bar
                            HStack {
                                Button(action: { dismiss() }) {
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


     

                               
                            

                        }
                        .ignoresSafeArea(.keyboard)
                        .navigationBarHidden(true)
                        .padding(.horizontal, 20)
                        .onAppear { webillConnect.loadWeBillAccount(context: context) }
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded { hideKeyboard() }
                    )
                    .padding(.bottom, min(keyboardResponder.currentHeight, 0))
                    Spacer()
                  
                    CustomButton(
                        title: "Disconnect",
                        action: {
                            showDisconnectAlert = true
                        },
                        backgroundColor: .red,
                        frameHeight: 55,
                        frameWidth: UIScreen.main.bounds.width * 0.9
                    )
         
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

                // Loading Indicator
                if webillConnect.isLoading {
                    LoadingViewForWebill()
                }

                // Success Popup
                if showMessage {
                    SuccessMessageForWeBill(
                        imageName: "SuccessCheck",
                        message: successMessage,
                        title: "Successfully",
                        color: .green
                    )
                    .transition(.opacity)
                }

                // Disconnect Confirmation Alert
                if showDisconnectAlert {
                    WeBillDisconnect(
                        onCancel: {
                            showDisconnectAlert = false
                        },
                        onYes: {
                            if isAccountDisconnected() {
                                isDisconnected = true
                            } else {
                                disconnectAccount()
                                showDisconnectAlert = false
                            }
                           
                        }
                    )
                }
                if isDisconnected {
                    SuccessMessageForWeBill(
                        imageName: "delete 1",
                        message: "You have already disconnected your webill account",
                        title: "Try again",
                        color: .red
                    )
                    .transition(.opacity)
                }

                // Error Alert
                if showError {
                    SuccessMessageForWeBill(
                        imageName: "delete 1",
                        message: "Please enter correct information webill account",
                        title: "Try again",
                        color: .red
                    )
                    .transition(.opacity)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    // MARK: - Validation Logic
    func validateAndSubmit() {
        // Reset errors
        resetFieldErrors()

        // Validate fields
        if validateFields() {
            let connectRequest = ConnectWebillConnectRequest(
                clientId: webillConnect.clientID,
                clientSecret: webillConnect.clientSecret,
                accountNo: webillConnect.parentAccountNo
            )
            
            // Fetch token
            webillConnect.fetchWeBillAccessToken(context: context) { isAccessTokenFetched in
                if isAccessTokenFetched {
                    webillConnect.ConnectWeBillAccount(ConnectRequest: connectRequest) { isConnected in
                        if isConnected {
                            webillConnect.isConnect = true
                            successMessage = webillConnect.successMessage.isEmpty ? "WeBill365 account connected successfully." : webillConnect.successMessage
                            showSuccessAndDismiss()
                        } else {
                            webillConnect.isConnect = false
                            showConnectionError()
                        }
                    }
                } else {
                    clearInputs()
                    webillConnect.isConnect = false
                    showTokenError()
                }
            }
        }
    }


    // MARK: - Disconnect Logic
    func disconnectAccount() {
        guard let clientId = Auth.shared.getClientId(), !clientId.isEmpty else {
            let error = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Client ID is missing or account already disconnected."]
            )
            showError(error)
            return
        }
        
        guard let secretID = Auth.shared.getSecret(), !secretID.isEmpty else {
            _ = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Secret ID is missing."]
            )
            return
        }
        
        guard let parentAccountNo = Auth.shared.getParentAccount(), !parentAccountNo.isEmpty else {
            _ = NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Parent account number is missing."]
            )
            return
        }
        
        // Assuming there's a way to check if the account is already disconnected:
        if isAccountDisconnected() {
            _ = NSError(
                domain: "",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Account is already disconnected."]
            )
            return
        }
        webillConnect.DisconnectWeBillaccount(context: context)
        webillConnect.clearWeBillAccount(context: context)
        
        successMessage = "WeBill365 account disconnected successfully."
        showifuserAlreadyDisconnect()
    }

    private func showifuserAlreadyDisconnect() {
           showMessage = true
           DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
               dismiss()
           }
       }

    // Helper function to check if the account is already disconnected
    func isAccountDisconnected() -> Bool {
        guard let clientId = Auth.shared.getClientId(), !clientId.isEmpty else {
            return true
        }
        return false
    }
    func showError(_ error: NSError) {
        print("Error: \(error.localizedDescription)")
    }

    // MARK: - Helper Methods
    private func resetFieldErrors() {
        clientIDError = nil
        secretIDError = nil
        accountNumberError = nil
    }

    private func validateFields() -> Bool {
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

        return !hasError
    }

    private func showSuccessAndDismiss() {
        showMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showMessage = false
            dismiss()
        }
    }

    private func showConnectionError() {
        webillConnect.errorMessage = "Failed to connect WeBill account."
        webillConnect.showError = true
    }

    private func showTokenError() {
        showError = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showError = false
            
        }
    }

    private func clearInputs() {
        webillConnect.clientID = ""
        webillConnect.clientSecret = ""
        webillConnect.parentAccountNo = ""
        webillConnect.clearWeBillAccount(context: context)
    }

    // MARK: - Field Section
       private func fieldSection(
           title: String,
           placeholder: String,
           text: Binding<String>,
           error: Binding<String?>,
           isSecure: Bool
       ) -> some View {
           VStack {
               HStack {
                   Text(title)
                       .font(.customfont(.medium, fontSize: 14))
                       .foregroundStyle(Color(hex: "#0A0019"))
                       .opacity(0.7)
                       .frame(maxWidth: .infinity, alignment: .leading)
               }

               if isSecure {
                   SecureField(placeholder, text: text)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .onChange(of: text.wrappedValue) { _ in error.wrappedValue = nil }
               } else {
                   TextField(placeholder, text: text)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .onChange(of: text.wrappedValue) { _ in error.wrappedValue = nil }
               }

               if let errorMsg = error.wrappedValue {
                   Text(errorMsg)
                       .font(.caption)
                       .foregroundColor(.red)
               }
           }
       }
}


// MARK: - Supporting Views

struct LoadingViewForWebill: View {
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                .scaleEffect(2)
                .offset(y: -50)
        }
    }
}

struct SuccessMessageForWeBill: View {
    var imageName: String
    var message: String
    var title: String
    var color: Color

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                Text(LocalizedStringKey(title))
                    .font(.customfont(.bold, fontSize: 20))
                    .foregroundStyle(color)
                Spacer().frame(height: 10)
                Text(LocalizedStringKey(message))
                    .font(.customfont(.regular, fontSize: 15))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .screenWidth * 0.65, maxHeight: 150)
            .padding(.horizontal, 30)
            .background(.white)
            .cornerRadius(24)
        }
    }
}
