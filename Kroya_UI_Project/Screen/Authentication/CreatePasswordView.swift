//
//
//import SwiftUI
//
//struct CreatePasswordView: View {
//    @State private var password = ""
//    @State private var confirmPassword = ""
//    @State private var isPasswordVisible1 = false
//    @State private var isPasswordVisible2 = false
//    @State private var errorMessage = ""
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var userStore: UserStore
//    @ObservedObject var authVM: AuthViewModel
//    @StateObject var addressViewModel = AddressViewModel(userStore: UserStore())
//    @State var isNav = false
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                VStack(alignment: .leading, spacing: 30) {
//                    // Custom Back Button
//                    HStack {
//                        Button(action: {
//                            dismiss() // Dismiss the view on button tap
//                        }) {
//                            Image(systemName: "arrow.left")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(.black)
//                        }
//                        Spacer()
//                    }
//                    .padding(.leading, 0)
//
//                    // Title
//                    Text("Create new password")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//
//                    // New Password and Confirm Password Fields
//                    VStack(spacing: 15) {
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("New password ") + Text("*").foregroundStyle(.red)
//                            PasswordField(
//                                iconName: "lock",
//                                placeholder: "Input your password",
//                                text: $password,
//                                isSecure: !isPasswordVisible1,  // Toggle visibility
//                                frameWidth: .screenWidth * 0.9
//                            )
//                        }
//
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("Confirm new password ") + Text("*").foregroundStyle(.red)
//                            PasswordField(
//                                iconName: "lock",
//                                placeholder: "Confirm your password",
//                                text: $confirmPassword,
//                                isSecure: !isPasswordVisible2,  // Toggle visibility
//                                frameWidth: .screenWidth * 0.9
//                            )
//                        }
//                        // Error message display
//                        if !errorMessage.isEmpty {
//                            Text(errorMessage)
//                                .foregroundColor(.red)
//                                .font(.caption)
//                                .padding(.bottom, 10)
//                                .frame(maxWidth: .infinity,alignment: .leading)
//                        }
//                    }.frame(maxWidth: .infinity,maxHeight: .screenHeight * 0.4,alignment: .top)
//                    .padding(.horizontal,6)
//                    .background(.yellow)
//
//
//
//
//                    // CREATE PASSWORD Button
//                    Button(action: {
//                        if validatePassword() {
//                            guard let email = userStore.user?.email else {
//                                print("Error: Email is missing")
//                                return
//                            }
//                            print("Creating password for email: \(email)")
//                            authVM.register(email, password) {
//                                authVM.isRegistered = true
//                            }
//                        }
//                    }) {
//                        Text("CREATE PASSWORD")
//                            .font(.customfont(.semibold, fontSize: 16))
//                            .frame(width: .screenWidth * 0.9, height: 50)
//                            .background(Color.yellow)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//
//                    Spacer()
//                }
//                .padding(.horizontal, 20)
//
//                NavigationLink(destination: UserBasicInfoView(authVM: authVM).environmentObject(userStore).environmentObject(addressViewModel), isActive: $authVM.isRegistered) {
//                    EmptyView()
//                }
//                .hidden()
//
//                if authVM.isLoading {
//                    ProgressIndicator()
//                }
//            }
//        }
//        .navigationBarHidden(true)
//    }
//
//    // Updated Password validation logic
//    func validatePassword() -> Bool {
//        guard !password.isEmpty, !confirmPassword.isEmpty else {
//            errorMessage = "Please fill in both fields."
//            return false
//        }
//        guard password == confirmPassword else {
//            errorMessage = "Passwords do not match."
//            return false
//        }
//        guard password.count >= 8 else {
//            errorMessage = "Password should be at least 8 characters."
//            return false
//        }
//
//        errorMessage = ""
//        return true
//    }
//}

import SwiftUI

struct CreatePasswordView: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible1 = false
    @State private var isPasswordVisible2 = false
    @State private var errorMessage = ""
    @State private var showPopupMessage = false 
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    @ObservedObject var authVM: AuthViewModel
    @StateObject var addressViewModel = AddressViewModel(userStore: UserStore())
    @State private var isNavigating = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 30) {
                    // Custom Back Button
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
                    .padding(.leading, 0)
                    
                    // Title
                    Text("Create new password")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    // New Password and Confirm Password Fields
                    VStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("New password ") + Text("*").foregroundStyle(.red)
                            PasswordField(
                                iconName: "lock",
                                placeholder: "Input your password",
                                text: $password,
                                isSecure: !isPasswordVisible1,
                                frameWidth: .screenWidth * 0.9
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Confirm new password ") + Text("*").foregroundStyle(.red)
                            PasswordField(
                                iconName: "lock",
                                placeholder: "Confirm your password",
                                text: $confirmPassword,
                                isSecure: !isPasswordVisible2,  // Toggle visibility
                                frameWidth: .screenWidth * 0.9
                            )
                        }
                        // Error message display
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .screenHeight * 0.4, alignment: .top)
                    .padding(.horizontal, 6)
                    
                    // CREATE PASSWORD Button
                    Button(action: {
                        if validatePassword() {
                            guard let email = userStore.user?.email else {
                                print("Error: Email is missing")
                                return
                            }
                            print("Creating password for email: \(email)")
                            authVM.register(email, password) {
                                authVM.isRegistered = true
                                showPopupMessage = true
                                
                                // After 2 seconds, hide popup and trigger navigation
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showPopupMessage = false
                                    isNavigating = true
                                }
                            }
                        }
                    }) {
                        Text("CREATE PASSWORD")
                            .font(.customfont(.semibold, fontSize: 16))
                            .frame(width: .screenWidth * 0.9, height: 50)
                            .background(Color.yellow)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
              
                if showPopupMessage {
                    PopupMessage()
                        .transition(.scale)
                }
                
             
                NavigationLink(destination: UserBasicInfoView(authVM: authVM).environmentObject(userStore).environmentObject(addressViewModel), isActive: $isNavigating) {
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
    
    // Password validation logic
    func validatePassword() -> Bool {
        guard !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in both fields."
            return false
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }
        guard password.count >= 8 else {
            errorMessage = "Password should be at least 8 characters."
            return false
        }
        
        errorMessage = ""
        return true
    }
}
