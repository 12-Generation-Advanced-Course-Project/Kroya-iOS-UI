







import SwiftUI
import Kingfisher
import Combine
import SDWebImageSwiftUI
struct EditingProfileView: View {
    @State private var userInputName: String = ""
    @State private var userInputEmail: String = ""
    @State private var userInputContact: String = ""
    @State private var userInputAddress: String = ""
    @State private var userInputPassword: String = ""
    @State private var showImagePicker = false
    @State private var selectedImages: [UIImage] = []
    @State private var isUpdating: Bool = false
    @ObservedObject var profile: ProfileViewModel
    @State private var isDeleteAccSheet: Bool = false
    @Environment(\.dismiss) var dismiss
    @Binding var selectedAddress: Address?
    @State private var imagefile: String = ""
    //    @EnvironmentObject var addressVM: AddressViewModel
    @EnvironmentObject var userStore: UserStore
    @State private var isPasswordVisible = false
    @Environment(\.locale) var locale
    @State private var showAddressSheet = false
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
//                HStack {
//                    Text(LocalizedStringKey("Edit Profile"))
//                        .font(.customfont(.bold, fontSize: 18))
//                        .opacity(0.84)
//                        .padding(.bottom, 20)
//                }
//                .frame(maxWidth: .infinity)
                
                // Profile Image and Edit Icon
                ZStack(alignment: .bottomTrailing) {
                    if selectedImages.isEmpty {
                        if let profileImageUrl = profile.userProfile?.profileImage, !profileImageUrl.isEmpty {
                            WebImage(url:URL(string: Constants.fileupload + "\(profileImageUrl)"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 94, height: 94)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color(hex:  "F4F5F7"))
                                .frame(width: 94, height: 94)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                )
                        }
                    } else {
                        Image(uiImage: selectedImages.last!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 33, height: 33)
                            .overlay(
                                Image("ico_pen")
                                    .foregroundColor(.white)
                                    .font(.customfont(.medium, fontSize: 20))
                            )
                    }
                }
                .padding(.top, 20)
                // Personal Info Section
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
                                .frame(width: locale.identifier == "ko" ? 80 : locale.identifier == "km-KH" ? 90 : 80, alignment: .leading)
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundColor(.black.opacity(0.8))
                            
                            TextField("Enter your full name", text: $userInputName)
                                .padding()
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .font(.customfont(.medium, fontSize: 16))
                            
                        }
                        .padding(.leading, 16)
                        .background(Color(hex: "F4F5F7"))
                        .cornerRadius(8)
                    }
                    
                    // Email Label and TextField (disabled)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(LocalizedStringKey("Email"))
                                .frame(width: locale.identifier == "ko" ? 80 : locale.identifier == "km-KH" ? 90 : 80, alignment: .leading)
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
                        .background(Color(hex: "F4F5F7"))
                        .cornerRadius(8)
                    }
                    
                    
                    // Mobile Label and TextField
                    VStack(alignment: .leading) {
                        HStack {
                            Text(LocalizedStringKey("Mobile"))
                                .frame(width: locale.identifier == "ko" ? 80 : locale.identifier == "km-KH" ? 90 : 80, alignment: .leading)
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundColor(.black.opacity(0.8))
                            
                            TextField("Enter your mobile number", text: $userInputContact)
                                .padding()
                                .foregroundColor(.black)
                                .cornerRadius(8)
                            
                                .font(.customfont(.medium, fontSize: 16))
                        }
                        .padding(.leading, 16)
                        .background(Color(hex: "F4F5F7"))
                        .cornerRadius(8)
                    }
                    
                    // Password Label and SecureField
                    VStack(alignment: .leading) {
                        HStack {
                            Text(LocalizedStringKey("Password"))
                                .frame(width: locale.identifier == "ko" ? 80 : locale.identifier == "km-KH" ? 90 : 80, alignment: .leading)
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundColor(.black.opacity(0.8))
                            
                            // Toggleable password field
                            (isPasswordVisible ? AnyView(TextField("Enter your password", text: $userInputPassword)) : AnyView(SecureField("Enter your password", text: $userInputPassword)))
                                .padding()
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .font(.customfont(.medium, fontSize: 16))
                                .disabled(true)
                            
                        }
                        .padding(.leading, 16)
                        .background(Color(hex: "F4F5F7"))
                        .cornerRadius(8)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Address")
                                .frame(width: locale.identifier == "ko" ? 80 : locale.identifier == "km-KH" ? 90 : 80, alignment: .leading)
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundColor(.black.opacity(0.8))
                            
                            Text(userInputAddress.isEmpty ? "Enter your address" : userInputAddress)
                                .padding()
                                .foregroundColor(.black.opacity(userInputAddress.isEmpty ? 0.3 : 1.0))
                                .font(.customfont(.medium, fontSize: 16))
                                .background(Color(hex: "F4F5F7"))
                                .cornerRadius(8)
                                .onTapGesture {
                                    showAddressSheet = true
                                    print("Tapped on address field. showAddressSheet is now \(showAddressSheet)")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 16)
                        .background(Color(hex: "F4F5F7"))
                        .cornerRadius(8)
                        .sheet(isPresented: $showAddressSheet) {
                            NavigationStack {
                                AddressView(
                                    onAddressSelected: { selectedAddress in
                                        // Handle selected address
                                        userInputAddress = selectedAddress.addressDetail
                                        print("Updated userInputAddress with selectedAddress.specificLocation: \(selectedAddress.addressDetail)")
                                    },
                                    isFromEditingProfileView: true // Pass true to indicate this view is coming from EditingProfileView
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                
                Spacer()
                // Save Button
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
                    
                }, backgroundColor: PrimaryColor.normal, frameHeight: 55,frameWidth: .screenWidth * 0.9)
                Text(LocalizedStringKey("Delete Account?"))
                    .font(.customfont(.medium, fontSize: 18))
                    .foregroundStyle(.red)
                    .padding()
                    .onTapGesture {
                        isDeleteAccSheet.toggle()
                    }
                    .sheet(isPresented: $isDeleteAccSheet) {
                        DeleteAccountDialog()
                            .presentationDetents([.fraction(0.30)])
                            .presentationDragIndicator(.visible)
                    }
                
                Spacer()
            }
            .onAppear {
                loadProfileData()
                //                addressVM.fetchAllAddresses()
                //                let lastaddress = addressVM.addresses.last
                //                selectedAddress = lastaddress
                profile.fetchUserProfile()
            }
            .onDisappear{
                profile.fetchUserProfile()
                loadProfileData()
                //                addressVM.fetchAllAddresses()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker { selectedImages, filenames in
                    for (index, filename) in filenames.enumerated() {
                        // Handle each filename and associated UIImage
                        print("Selected image filename: \(filename)")
                        
                        // Append each selected image to the list
                        if index < selectedImages.count {
                            let uiImage = selectedImages[index]
                            self.selectedImages.append(uiImage)
                        }
                    }
                }
            }

            
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Function to load UIImage from filename if needed
    private func loadImageFromFile(_ filename: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    // Helper to get the Documents directory path
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private func loadProfileData() {
        userInputName = profile.userProfile?.fullName ?? "N/A"
        userInputEmail = profile.userProfile?.email ?? ""
        userInputContact = profile.userProfile?.phoneNumber ?? ""
        userInputPassword = profile.userProfile?.password ?? ""
        userInputAddress = selectedAddress?.specificLocation ?? ""
    }
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
    private func formatPhoneNumber() {
        let digits = userInputContact.filter { $0.isNumber }
        let formatted = digits.prefix(9)
        userInputContact = formatted.enumerated().map { index, char in
            if index == 3 || index == 6 { return "-\(char)" }
            return "\(char)"
        }.joined()
    }
    
}

struct DeleteAccountDialog: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                Text("Delete your account?")
                    .font(.customfont(.medium, fontSize: 18))
                    .foregroundStyle(.black.opacity(0.7))
                    .padding(.vertical)
            }
            VStack {
                CustomButton(title: "Delete", action: {print("Delete Account Clicked")}, backgroundColor: .red, frameHeight: 55,cornerRadius: 16,frameWidth: .screenWidth * 0.9)
                
                CustomButton(title: "Cancel", action: {print("Cancel Account Clicked")
                    dismiss()
                }, backgroundColor: .white,textColor: .black, frameHeight: 55,cornerRadius: 16,frameWidth: .screenWidth * 0.9).overlay {
                    RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.4), lineWidth: 0.5)
                }
            }
            .padding()
        }
        .padding(.top,5)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    
}

#Preview {
    EditingProfileView(profile: ProfileViewModel(), selectedAddress: .constant(nil))
}
