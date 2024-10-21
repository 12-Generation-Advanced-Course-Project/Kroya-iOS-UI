

import SwiftUI

struct CreatePasswordView: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible1 = false
    @State private var isPasswordVisible2 = false
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    @ObservedObject var authVM: AuthViewModel
//    
//    // Initialize the AuthViewModel in the initializer
//    init(userStore: UserStore) {
//        _authVM = StateObject(wrappedValue: AuthViewModel(userStore: userStore))
//    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 30) {
                // Custom Back Button
                HStack {
                    Button(action: {
                        dismiss() // Dismiss the view on button tap
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
                            isSecure: true,
                            frameWidth: .screenWidth * 0.9
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Confirm new password ") + Text("*").foregroundStyle(.red)
                        PasswordField(
                            iconName: "lock",
                            placeholder: "Confirm your password",
                            text: $confirmPassword,
                            isSecure: true,
                            frameWidth: .screenWidth * 0.9
                        )
                    }
                }
                .padding(.bottom, 10)
                
                // Error message display
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom, 10)
                }
                
                // Create Password Button with validation logic
                NavigationLink(destination: MainScreen().navigationBarBackButtonHidden(true),isActive: $authVM.isRegistered) {
                    EmptyView()
                }
                
                Button(action: {
                    if validatePassword() {
                        print("Password created successfully")
                        authVM.register(userStore.user?.email ?? "bonalyhengun@gmail.com", password, confirmPassword)
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
            .navigationBarHidden(true)
            
            if authVM.isLoading {
                ProgressIndicator()
            }
        }
    }
    
    // Password validation logic
    func validatePassword() -> Bool {
        if password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill in both fields."
            return false
        } else if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        } else if password.count < 6 {
            errorMessage = "Password should be at least 6 characters."
            return false
        }
        errorMessage = ""
        return true
    }
}
