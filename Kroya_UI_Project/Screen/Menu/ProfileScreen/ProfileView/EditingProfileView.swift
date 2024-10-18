import SwiftUI

struct EditingProfileView: View {
    
    @State private var userInputName = ""
    @State private var userInputEmail = ""
    @State private var userInputContact = ""
    @State private var userInputPassword = ""
    @State private var userInputAddress = ""
    @State var showBottomSheet: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let frameHeightCircle = screenHeight / 8
            let frameWidthButton = screenHeight / 10
            let frameHeightIcon = screenHeight * 0.05
            let iconSize = frameHeightCircle / 2
            
            VStack(spacing: 10) {
                HStack {
                    Text("Edit Profile")
                        .font(.customfont(.bold, fontSize: 18))
                        .opacity(0.84)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                
                // Profile Image and Edit Icon
                ZStack(alignment: .bottomTrailing) {
                    
                    // Profile Circle
                    Circle()
                        .fill(Color(hex: "#D9D9D9"))
                        .frame(width: frameHeightCircle, height: frameHeightCircle)
                        .overlay(
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: frameHeightIcon, height: frameHeightIcon)
                                .foregroundStyle(Color.white)
                        )
                    
                    
                    Button(action: {
                        // action button
                    }) {
                        Circle()
                            .fill(Color(hex: "#FECD36"))
                            .frame(width: iconSize / 1.5, height: iconSize / 1.5)
                            .overlay(
                                Image("ico_pen")
                                    .resizable()
                                    .frame(width: iconSize / 2 , height: iconSize / 2)
                                    .foregroundColor(.white)
                            )
                    }
                }.padding(.bottom, 20)
                
                VStack(spacing: 13){
                    HStack{
                        Text("Personal info")
                            .foregroundStyle(Color(hex: "#0A0019"))
                            .opacity(0.6)
                            .font(.customfont(.regular, fontSize: 14))
                        Spacer()
                    }
                    Text_field(text: $userInputName, label: "Full Name:")
                    Text_field(text: $userInputEmail, label: "Email:")
                    Text_field(text: $userInputContact, label: "Mobile:")
                    PasswordFieldd(password: $userInputPassword, label: "Password:")
                    Text_field(text: $userInputAddress, label: "Address:")
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomButton(title: "Save", action: {
                    print("Button tapped!")
                }, backgroundColor: PrimaryColor.normal,frameHeight: 55, frameWidth: frameWidthButton * 4.7)
                
                Spacer().frame(height: 2)
                
                // Button to trigger the bottom sheet
                Button(action: {
                               showBottomSheet.toggle()
                           }) {
                               Text("Delete account?")
                                   .foregroundColor(.red)
                                   .font(.system(size: 17, weight: .medium))
                           }
                
            
                
                Spacer()
           }
          //  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
            .sheet(isPresented: $showBottomSheet) {
                // Custom Bottom Sheet View
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        // Top indicator for the sheet
                        Capsule()
                            .frame(width: 45, height: 4)
                            .foregroundColor(Color.gray.opacity(0.5))
                            .padding(.top, 10)
                        
                        // Trash icon and title
                        HStack(spacing: 10) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.black)
                            Text("Delete your account?")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        // Delete Button
                        Button(action: {
                            // Handle delete action
                            print("Delete tapped")
                        }) {
                            Text("Delete")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        
                        // Cancel Button
                        Button(action: {
                            showBottomSheet = false
                        }) {
                            Text("Cancel")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                    }
                    .padding(.horizontal, 30)
                    //.padding(.bottom, 30)
     .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                   // .shadow(radius: 10)
                    .frame(height: UIScreen.main.bounds.height / 4 * 1.1) // 1/3 of the screen height
                }
                .opacity(0.3) // Background overlay
                
                
            }
   

        }
    }
}

#Preview {
    EditingProfileView()
}
