import SwiftUI

struct EditingProfileView: View {
    
    @State private var userInputName = ""
    @State private var userInputEmail = ""
    @State private var userInputContact = ""
    @State private var userInputPassword = ""
    @State private var userInputAddress = ""
    @State private var showBottomSheet : Bool = false
    
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
                    Text_field(text: $userInputName, label: "Full Name")
                    Text_field(text: $userInputEmail, label: "Email")
                    Text_field(text: $userInputContact, label: "Mobile")
                    PasswordFieldd(password: $userInputPassword, label: "Password")
                    Text_field(text: $userInputAddress, label: "Address")
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomButton(title: "Save", action: {
                    print("Button tapped!")
                }, backgroundColor: PrimaryColor.normal, frameWidth: frameWidthButton * 4.7)
                
                Spacer().frame(height: 5)
                
                Button(action: {
                    showBottomSheet.toggle()
                }){
                    Text("Delete account?")
                        .font(.customfont(.medium, fontSize: 17))
                        .foregroundStyle(Color.red)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            // Bottom Sheet
            if showBottomSheet {
                VStack {
                    Spacer()

                    // The sheet content
                    VStack(spacing: 20) {
                        
                        // Drag handle capsule
                        Button(action: {}){
                            Capsule()
                                .frame(width: 45, height: 4)
                                .foregroundColor(Color.gray)
                                .opacity(0.5)
                                .padding(.top, 10)
                                .onTapGesture {
                                    showBottomSheet.toggle() // Allow dismissing the bottom sheet by tapping the capsule
                                }
                        }
                          
                        
                        HStack{
                            Image(systemName: "trash.fill")
                            Text("Delete your account")
                                .font(.customfont(.medium, fontSize: 20))
                        }
                        .padding(.bottom, 10)
//                        .onTapGesture {
//                            print("Delete Account Label tapped!")
//                        }

                        // Delete Button
                        CustomButton(title: "Delete", action: {
                            print("Delete!")
                            showBottomSheet.toggle() // Close the sheet after action
                        }, backgroundColor: Color.red, frameHeight: frameHeightIcon * 1.25, frameWidth: frameWidthButton * 4.7)
                        .onTapGesture {
                            print("Delete Button tapped!")
                            showBottomSheet.toggle()
                        }

                        // Cancel Button
                        CustomButton(title: "Cancel", action: {
                            print("Cancel!")
                            showBottomSheet.toggle() // Close the sheet
                        }, backgroundColor: Color.white, textColor: .black, frameHeight: frameHeightIcon * 1.25, frameWidth: frameWidthButton * 4.7)
                        .shadow(radius: 1)
                        .onTapGesture {
                            print("Cancel Button tapped!")
                            showBottomSheet.toggle() // Close the sheet
                        }

                        Spacer()
                    }
                    .frame(height: UIScreen.main.bounds.height / 4 * 1.1) // 1/4 of the screen height
                    .background(Color(hex: "#F3F5F7"))
                    .cornerRadius(20)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
                }
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showBottomSheet.toggle() // Close the sheet
                }
                
            }
        }
    }
}

#Preview {
    EditingProfileView()
}
