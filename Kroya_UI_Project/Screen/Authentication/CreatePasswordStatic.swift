import SwiftUI

struct CreatePasswordStatic: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible1 = false
    @State private var isPasswordVisible2 = false
    @State private var errorMessage = ""
    @State private var showPopupMessage = false
    @EnvironmentObject var userStore: UserStore
    @Environment(\.dismiss) var dismiss
    @State private var isgoMainscreen = false
    @Binding var lang: String
    @ObservedObject var authVM: AuthViewModel
    var Email: String
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
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
                
                // Title
                Text("Reset password")
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
                            frameWidth: .infinity // Makes the width adapt to available space
                        )
                        .onChange(of: password) { _ in
                            validatePasswordFields()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Confirm new password ") + Text("*").foregroundStyle(.red)
                        PasswordField(
                            iconName: "lock",
                            placeholder: "Confirm your password",
                            text: $confirmPassword,
                            isSecure: !isPasswordVisible2,
                            frameWidth: .infinity
                        )
                        .onChange(of: confirmPassword) { _ in
                            validatePasswordFields()
                        }
                    }
                    
                    // Error message display
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("") // Placeholder to maintain layout consistency
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 6)
                
                // Reset Password Button
                Button(action: {
                    if validatePasswordFields() {
                        authVM.register(Email, password) {
                            showPopupMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showPopupMessage = false
                                isgoMainscreen = true
                            }
                        }
                    }
                }) {
                    Text("CREATE NEW PASSWORD")
                        .font(.customfont(.semibold, fontSize: 16))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            NavigationLink(
                destination: MainScreen(lang: $lang)
                    .environmentObject(userStore)
                    .environmentObject(authVM),
                isActive: $isgoMainscreen
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarHidden(true)
    }
    
    // Password validation logic
    // Validation Function
    private func validatePasswordFields() -> Bool {
        if password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill in both fields."
            return false
        } else if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        } else if !isValidPassword(password) {
            errorMessage = "Password must be at least 8 characters and include a special character."
            return false
        }
        errorMessage = "" // Clear the error if validation passes
        return true
    }

    // Regex-based Password Validation
    private func isValidPassword(_ password: String) -> Bool {
        let regex = #"^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
}
