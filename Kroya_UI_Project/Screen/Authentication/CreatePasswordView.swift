



import SwiftUI

struct CreatePasswordView: View {
    @State private var password = ""
    @State private var ConfirmPassword = ""
    @State private var isPasswordVisible1 = true
    @State private var isPasswordVisible2 = true
    @Environment(\.dismiss) var dismiss
  
    var body: some View {
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
                        isSecure: isPasswordVisible1,
                        frameWidth: .screenWidth * 0.9
                    )
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Confirm New password ") + Text("*").foregroundStyle(.red)
                    PasswordField(
                        iconName: "lock",
                        placeholder: "Confirm your password",
                        text: $ConfirmPassword,
                        isSecure: isPasswordVisible2,
                        frameWidth: .screenWidth * 0.9
                    )
                }
            }
            .padding(.bottom, 10)

            // Create Password Button
            NavigationLink(destination: UserBasicInfoView()) {
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
        .navigationBarHidden(true) // This hides the navigation bar in this view
    }
}

//#Preview {
//    CreatePasswordView()
//}

