import SwiftUI

struct UserBasicInfoView: View {
    
    @State private var textName = ""
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var showSuccessAlert = false
    @State private var selectedAddress: Address?
    
    // Validation flags
    @State private var isNameEmpty = false
    @State private var isPhoneNumberEmpty = false
    @State private var isPhoneNumberInvalid = false // New flag for invalid phone number
    @State private var isAddressEmpty = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var addressVM: AddressViewModel
    @ObservedObject var authVM = AuthViewModel(userStore: UserStore())
    @Binding var lang: String
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
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
                Text("Basic Information")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                //MARK: User Input
                VStack(spacing: 5) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Username")
                            .font(.callout)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.gray)
                        InputField(iconName: "person.text.rectangle", placeholder: "Full name", text: $textName, frameWidth: .infinity, isMultiline: false)
                            .onChange(of: textName) { newValue in
                                isNameEmpty = newValue.isEmpty
                            }
                        if isNameEmpty {
                            Text("Please enter your name")
                                .font(.caption)
                                .foregroundColor(.red)
                                .font(.customfont(.medium, fontSize: 14))
                        }
                        Spacer()
                    }
                    .frame(height: .screenHeight * 0.15)
                    
                    //MARK: Phone Number
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Phone Number")
                            .font(.callout)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.gray)
                        InputField(iconName: "phone.fill", placeholder: "Enter phone number", text: $phoneNumber, frameWidth: .infinity, isMultiline: false)
                            .onChange(of: phoneNumber) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    isPhoneNumberInvalid = true
                                    phoneNumber = filtered // Only allow numeric input
                                } else {
                                    isPhoneNumberInvalid = false
                                }
                                isPhoneNumberEmpty = phoneNumber.isEmpty
                            }
                        if isPhoneNumberEmpty {
                            Text("Please enter a valid phone number")
                                .font(.caption)
                                .foregroundColor(.red)
                                .font(.customfont(.medium, fontSize: 14))
                        } else if isPhoneNumberInvalid {
                            Text("Phone number can only contain digits")
                                .font(.caption)
                                .foregroundColor(.red)
                                .font(.customfont(.medium, fontSize: 14))
                        }
                        Spacer()
                    }.frame(height: .screenHeight * 0.15)
                    
                    //MARK: Address
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Address")
                            .font(.callout)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.gray)
                        
                        // Address Selection NavigationLink
                        NavigationLink(destination: AddressView(viewModel: addressVM, selectedAddress: $selectedAddress)) {
                            HStack {
                                Image("pinmap")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                                Text(selectedAddress?.specificLocation ?? "Select Address")
                                    .font(.customfont(.regular, fontSize: 18))
                                    .padding(.vertical, 20)
                                    .foregroundColor(.gray)
                                    .keyboardType(.default)
                                    .frame(width: .screenWidth * 0.6, alignment: .leading)
                                
                                Spacer()
                            }
                            .background(Color(hex: "#F2F2F7"))
                            .cornerRadius(10)
                            .frame(height: 60)
                        }
                        .onChange(of: selectedAddress) { newValue in
                            isAddressEmpty = newValue == nil
                        }
                        
                        if isAddressEmpty {
                            Text("Please select an address")
                                .font(.caption)
                                .foregroundColor(.red)
                                .font(.customfont(.medium, fontSize: 14))
                        }
                        Spacer()
                    }.frame(height: .screenHeight * 0.15)
                    
                }
                .padding(.bottom, 20)
                // Save Button
                Button(action: {
                    validateAndSaveUserInfo()
                }) {
                    Text("Save")
                        .font(.customfont(.semibold, fontSize: 16))
                        .frame(width: .screenWidth * 0.83)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                NavigationLink(destination: MainScreen(lang: $lang).environmentObject(userStore), label: {
                    Text("Skip")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.green)
                    
                }
                )
                
                Spacer()
            }
            .padding(.horizontal, 20)
            NavigationLink(destination: MainScreen(lang: $lang).environmentObject(userStore),isActive: $authVM.isUserSave, label: {
                EmptyView()
            })
            .hidden()
           
        }
        
        .navigationBarHidden(true)
        
    }
    
    func validateAndSaveUserInfo() {
        // Reset validation flags
        isNameEmpty = textName.isEmpty
        isPhoneNumberEmpty = phoneNumber.isEmpty
        isAddressEmpty = selectedAddress == nil
        
        // If any field is empty, return without saving
        if isNameEmpty || isPhoneNumberEmpty || isAddressEmpty || isPhoneNumberInvalid {
            return
        }
        
        // If all fields are valid, proceed to save
        isLoading = true
        authVM.saveUserInfo(
            email: userStore.user?.email ?? "No Email",
            userName: textName,
            phoneNumber: phoneNumber,
            address: selectedAddress?.specificLocation ?? "No Address"
            ,accessToken: userStore.user?.accesstoken ?? ""
            ,refreshToken: userStore.user?.refreshtoken ?? ""
        )
        
        isLoading = false
    }
}
