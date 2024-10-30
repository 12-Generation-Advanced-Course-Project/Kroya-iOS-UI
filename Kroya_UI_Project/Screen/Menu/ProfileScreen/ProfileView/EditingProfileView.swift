



import SwiftUI
import Kingfisher
import Combine

struct EditingProfileView: View {
    @State private var userInputName: String = ""
    @State private var userInputEmail: String = ""
    @State private var userInputContact: String = ""
    @State private var userInputPassword: String = ""
    @State private var userInputAddress: String = ""
    @State private var showImagePicker = false
    @State private var selectedImages: [UIImage] = []
    @State private var isShowingNavigation = false
    @ObservedObject var profile: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var imagefile: String = ""
    @State private var isUpdating: Bool = false
    @Binding var selectedAddress: Address?
    @StateObject var viewModel: AddressViewModel
    var urlimage: String = "https://kroya-api.up.railway.app/api/v1/fileView/"
    @State var Location: Address?
    @State private var isPasswordVisible = false // State variable to toggle password visibility
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height
                let frameHeightCircle = screenHeight / 8
                let frameHeightIcon = screenHeight * 0.05
                let iconSize = frameHeightCircle / 2
                
                VStack(spacing: 10) {
                    HStack {
                        Text(LocalizedStringKey("Edit profile"))
                            .font(.customfont(.bold, fontSize: 18))
                            .opacity(0.84)
                            .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Profile Image and Edit Icon
                    ZStack(alignment: .bottomTrailing) {
                        if selectedImages.isEmpty {
                            if let profileImageUrl = profile.userProfile?.profileImage, !profileImageUrl.isEmpty {
                                KFImage(URL(string: "\(urlimage)\(profileImageUrl)"))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: frameHeightCircle, height: frameHeightCircle)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color(hex: "#D9D9D9"))
                                    .frame(width: frameHeightCircle, height: frameHeightCircle)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: frameHeightIcon, height: frameHeightIcon)
                                            .foregroundStyle(Color.white)
                                    )
                            }
                        } else {
                            Image(uiImage: selectedImages.last!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: frameHeightCircle, height: frameHeightCircle)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                        
                        Button(action: {
                            showImagePicker = true
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
                    
                    // Personal Info Section
                    //                    VStack(spacing: 13) {
                    //                        HStack {
                    //                            Text("Personal info")
                    //                                .foregroundStyle(Color(hex: "#0A0019"))
                    //                                .opacity(0.6)
                    //                                .font(.customfont(.regular, fontSize: 14))
                    //                            Spacer()
                    //                        }
                    //
                    //                        Text_field(text: $userInputName, label: "Full Name:", backgroundColor: .white.opacity(0.8),fontcolor: .black)
                    //                        Text_field(text: $userInputEmail, label: "Email:", backgroundColor: .white.opacity(0.8),fontcolor: .black.opacity(0.5)).disabled(true)
                    //                        Text_field(text: $userInputContact, label: "Mobile:", backgroundColor: .white.opacity(0.8),fontcolor: .black)
                    //                        PasswordFieldd(password: $userInputPassword, backgroundColor: .white.opacity(0.8), label: "Password:").lineLimit(1)
                    //                        // Address Field linked to the selectedAddress
                    //                        Text_field(text: $userInputAddress, label: "Address:", backgroundColor: .white.opacity(0.8),fontcolor: .black.opacity(0.5)).disabled(true)
                    //                    }
                    
                    VStack(alignment: .leading) {
                        Text("Personal info")
                            .foregroundStyle(Color(hex: "#0A0019"))
                            .opacity(0.6)
                            .font(.customfont(.regular, fontSize: 14))
                            .padding(.trailing,25)
                            .padding(.vertical,10)
                            .background(Color.white.opacity(0.2))
                        
                        // Full Name Label and TextField
                        VStack(alignment: .leading) {
                            HStack {
                                Text(LocalizedStringKey("Full name"))
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(.black.opacity(0.8))
                                TextField("Enter your full name", text: $userInputName)
                                    .padding()
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                    .font(.customfont(.medium, fontSize: 16))
                            }
                            .padding(.leading, 16)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Email Label and TextField (disabled)
                        VStack(alignment: .leading) {
                            HStack {
                                Text(LocalizedStringKey("Email"))
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(.black.opacity(0.8))
                                TextField("Enter your email", text: $userInputEmail)
                                    .padding()
                                    .foregroundColor(.black.opacity(0.5))
                                    .cornerRadius(8)
                                    .font(.customfont(.medium, fontSize: 16))
                                    .disabled(true)
                            }
                            .padding(.leading, 16)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Mobile Label and TextField
                        VStack(alignment: .leading) {
                            HStack(spacing: 10){
                                Text(LocalizedStringKey("Mobile"))
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(.black.opacity(0.8))
                                TextField("Enter your mobile number", text: $userInputContact)
                                    .padding()
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                    .font(.customfont(.medium, fontSize: 16))
                            }
                            .padding(.leading, 16)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Password Label and SecureField
                        VStack(alignment: .leading) {
                            HStack {
                                Text(LocalizedStringKey("Password"))
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(.black.opacity(0.8))
                                // Toggleable password field
                                (isPasswordVisible ? AnyView(TextField("Enter your password", text: $userInputPassword)) : AnyView(SecureField("Enter your password", text: $userInputPassword)))
                                    .padding()
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                    .font(.customfont(.medium, fontSize: 16))
                                
//                                // Eye icon to toggle password visibility
//                                Button(action: {
//                                    isPasswordVisible.toggle() // Toggle visibility
//                                }) {
//                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
//                                        .foregroundColor(.black)
//                                        .font(.customfont(.medium, fontSize: 16))
//                                }
//                                .padding(.trailing, 16)
//                                .padding(.leading, 5) // Space between the text field and the icon
                            }
                            .padding(.leading, 16)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Address Label and TextField (disabled)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Address")
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(.black.opacity(0.8))
                                TextField("Enter your address", text: $userInputAddress)
                                    .padding()
                                    .foregroundColor(.black.opacity(0.5))
                                    .font(.customfont(.medium, fontSize: 16))
                                    .disabled(true)
                            }
                            .padding(.leading, 16)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Save button
                    CustomButton(title: "Save", action: {
                        print("Save tapped!")
                        isUpdating = true
                        if let selectedImage = selectedImages.last {
                            // Upload the selected image
                            if let imageData = selectedImage.jpegData(compressionQuality: 0.2) {
                                let imageExtension = detectImageFormat(data: imageData)
                                let imageName = "\(UUID().uuidString).\(imageExtension)"
                                print("Generated Image Name: \(imageName)")
                                self.imagefile = "\(imageName)"
                                
                                // Upload the image and update profile
                                ImageUploadViewModel().uploadFile(image: imageData) { uploadedImageUrl in
                                    print("Uploaded Image URL: \(uploadedImageUrl)")
                                    if let imageFileName = uploadedImageUrl.split(separator: "/").last {
                                        profile.updateUserProfile(
                                            fullName: userInputName,
                                            phoneNumber: userInputContact,
                                            address: userInputAddress,
                                            profileImage: String(imageFileName)
                                        ) { success in
                                            isUpdating = false
                                            if success {
                                                print("Profile updated successfully.")
                                                dismiss()
                                            } else {
                                                print("Failed to update profile.")
                                            }
                                        }
                                    } else {
                                        print("Failed to extract image file name from URL.")
                                        isUpdating = false
                                    }
                                }
                            }
                        } else {
                            // Update profile without changing the image
                            profile.updateUserProfile(
                                fullName: userInputName,
                                phoneNumber: userInputContact,
                                address: userInputAddress,
                                profileImage: profile.userProfile?.profileImage ?? ""
                            ) { success in
                                isUpdating = false
                                if success {
                                    print("Profile updated successfully.")
                                    dismiss()
                                } else {
                                    print("Failed to update profile.")
                                }
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss()
                        }
                        
                    }, backgroundColor: PrimaryColor.normal, frameHeight: 55)
                    
                    Spacer().frame(height: 2)
                    Spacer()
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImages: $selectedImages)
                        .onChange(of: selectedImages) { newImages in
                            if let selectedImage = newImages.last,
                               let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                                let imageExtension = detectImageFormat(data: imageData)
                                let imageName = "\(UUID().uuidString).\(imageExtension)"
                                print("Generated Image Name: \(imageName)")
                            }
                        }
                }
                .onAppear {
                    loadProfileData()
                    //                    if let  lastAddress = viewModel.addresses.last {
                    //                        selectedAddress = lastAddress
                    //                    }
                }
                .onDisappear{
                    viewModel.fetchAllAddresses()
                    profile.fetchUserProfile()
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
        
    }
    
    private func loadProfileData() {
        userInputName = profile.userProfile?.fullName ?? "No Name"
        userInputEmail = profile.userProfile?.email ?? ""
        userInputContact = profile.userProfile?.phoneNumber ?? ""
        userInputPassword = profile.userProfile?.password ?? ""
        userInputAddress =  selectedAddress?.specificLocation ?? ""
    }
    
    // Function to detect image format from data
    private func detectImageFormat(data: Data) -> String {
        let headerBytes = [UInt8](data.prefix(1))
        switch headerBytes {
        case [0x89]:
            return "png"
        case [0xFF]:
            return "jpg"
        default:
            return "jpeg"
        }
    }
}
