import SwiftUI

struct EditingProfileView: View {
    
    @State private var userInputName = ""
    @State private var userInputEmail = ""
    @State private var userInputContact = ""
    @State private var userInputPassword = ""
    @State private var userInputAddress = ""
    @State private var showImagePicker = false
    @State private var selectedImages: [UIImage] = [] // Store selected images
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let frameHeightCircle = screenHeight / 8
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
                    
                    if selectedImages.isEmpty {
                        // Show default profile icon if no images are selected
                        Circle()
                            .fill(Color(hex: "#D9D9D9"))
                            .frame(width: frameHeightCircle, height: frameHeightCircle)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: frameHeightIcon, height: frameHeightIcon)
                                    .foregroundStyle(Color.white)
                            )
                    } else {
                        // Display the first selected image as profile
                        Image(uiImage: selectedImages.first!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: frameHeightCircle, height: frameHeightCircle)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                    
                    // Edit Button to open ImagePicker
                    Button(action: {
                        showImagePicker = true // Trigger the image picker
                    }) {
                        Circle()
                            .fill(Color(hex: "#FECD36"))
                            .frame(width: iconSize / 1.5, height: iconSize / 1.5)
                            .overlay(
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: iconSize / 2 , height: iconSize / 2)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.bottom, 20)
                
                // Other UI elements
                VStack(spacing: 13) {
                    HStack {
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
                }, backgroundColor: PrimaryColor.normal, frameHeight: 55)
                
                Spacer().frame(height: 2)
                
                Spacer()
            }
            .sheet(isPresented: $showImagePicker) {
                // ImagePicker that allows multiple selection
                ImagePicker(selectedImages: $selectedImages)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    EditingProfileView()
}
