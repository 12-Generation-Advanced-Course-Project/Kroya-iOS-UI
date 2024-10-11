



import SwiftUI

struct LoginScreenView: View {
    @State private var phoneNumber: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    // Image Header
                    Image("food_background")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                    
                    // Linear Gradient Overlay
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    .offset(y: 170)
                }
                
                // Logo
                Image("KroyaYellowLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .offset(y: -25)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email")
                        .foregroundStyle(.black.opacity(0.5))
                        .font(.customfont(.regular, fontSize: 14))
                    // Use InputField component
                    InputField(
                        iconName: "mail.fill",
                        placeholder: "example@gmail.com",
                        text: $phoneNumber,
                        frameWidth: .infinity,
                        colorBorder: .white,
                        isMultiline: false
                    )
                }
                .padding()
                .padding(.top, -70)
                
                NavigationLink(destination: FillPasswordScreen(), label: {
                    Text("GET STARTED")
                        .font(.customfont(.semibold, fontSize: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                  }
                )
//                // Get Started Button
//                CustomButton(
//                    title: "GET STARTED",
//                    action: {
//                        print("Get Started Button Tapped")
//                    },
//                    backgroundColor: .yellow,
//                    textColor: .white,
//                    frameHeight: .screenHeight * 0.06,
//                    cornerRadius: 10,
//                    fontSize: 18,
//                    frameWidth: .screenWidth * 0.92
//                )
//                .padding(.top, 10)
                // Login as Guest Button
                Button(action: {
                    
                }) {
                    Text("Login as guest")
                        .font(.customfont(.bold, fontSize: 12))
                        .foregroundColor(.black.opacity(0.6))
                }
                .padding(.top, 15)
                
                Spacer()
                
                // Terms of Service and Privacy Policy
                VStack(spacing: 2) {
                    Text("By clicking “ GET STARTED ” you agreed to our")
                        .font(.customfont(.regular, fontSize: 12))
                    
                    HStack {
                        Button(action: {
                            // Terms of Service action
                        }) {
                            Text("Terms of Service")
                                .underline()
                                .foregroundColor(.green)
                        }
                        
                        Text("and")
                        
                        Button(action: {
                            // Privacy action
                        }) {
                            Text("Privacy")
                                .underline()
                                .foregroundColor(.green)
                        }
                    }
                }
                .font(.customfont(.regular, fontSize: 12))
                .padding(.bottom, 20)
            }
            
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginScreenView()
}

