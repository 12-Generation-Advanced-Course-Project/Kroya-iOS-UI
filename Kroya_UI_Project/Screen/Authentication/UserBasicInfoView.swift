import SwiftUI

struct UserBasicInfoView: View {
    
    @State private var textName = ""
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var showSuccessAlert = false
    @State private var selectedAddress: Address?
    @State private var isSkip = false
    
    @State private var isNameEmpty = false
    @State private var isPhoneNumberEmpty = false
    @State private var isPhoneNumberInvalid = false
    @State private var isAddressEmpty = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    //    @EnvironmentObject var addressVM: AddressViewModel
    //    @ObservedObject var authVM = AuthViewModel(userStore: UserStore())
    @EnvironmentObject var authVM: AuthViewModel // Use EnvironmentObject
    
    @Binding var lang: String
    @State private var showAddressSheet = false
    @State private var userInputAddress: String = ""
    @State private var navigateToMainScreen = false
    @State private var showError = false
    @State private var successMessage = ""
    
    var body: some View {
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
            
            Text("Basic Information")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            //MARK: User Input
            VStack(spacing: 5) {
                // Username input
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
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    }
                }
                
                // Phone Number input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Phone Number")
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.gray)
                    InputField(iconName: "phone.fill", placeholder: "Enter phone number", text: $phoneNumber, frameWidth: .infinity, isMultiline: false)
                        .onChange(of: phoneNumber) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                isPhoneNumberInvalid = true
                                phoneNumber = filtered
                            } else {
                                isPhoneNumberInvalid = false
                            }
                            isPhoneNumberEmpty = phoneNumber.isEmpty
                        }
                    if isPhoneNumberEmpty {
                        Text("Please enter a valid phone number")
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    } else if isPhoneNumberInvalid {
                        Text("Phone number can only contain digits")
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    }
                }
                
                // Address input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Address")
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.gray)
                    HStack {
                        Image("pinmap")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                        Text(userInputAddress.isEmpty ? "Select Address" : userInputAddress)
                            .font(.customfont(.regular, fontSize: 18))
                            .padding(.vertical, 20)
                            .foregroundColor(.gray)
                            .frame(width: .screenWidth * 0.6, alignment: .leading)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        showAddressSheet = true
                        print("Tapped on address field. showAddressSheet is now \(showAddressSheet)")
                    }
                    .sheet(isPresented: $showAddressSheet) {
                        NavigationStack {
                            AddressView(
                                onAddressSelected: { selected in
                                    selectedAddress = selected
                                    userInputAddress = selectedAddress?.addressDetail ?? ""
                                    print("Selected address: \(selectedAddress)")
                                },
                                isFromEditingProfileView: true
                            )
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(Color(hex: "#F2F2F7"))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(height: 60)
                    
                    if isAddressEmpty {
                        Text("Please select an address")
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .screenHeight * 0.4)
            
            // Save Button
            Button(action: {
                validateAndSaveUserInfo()
                Auth.shared.loggedIn = true
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
            
            // Skip Button
            Button(action: {
                isSkip.toggle()
            }) {
                Text("Skip")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundColor(PrimaryColor.normal)
            }
            
            Spacer()
            
            //            // NavigationLink to MainScreen for save action
            //            NavigationLink(destination: MainScreen(userStore: userStore, lang: $lang)
            //                .environmentObject(userStore),
            //                           isActive: $authVM.isUserSave, label: {
            //                EmptyView()
            //            })
            //            .hidden()
            // NavigationLink to MainScreen for save action
            NavigationLink(
                destination: MainScreen(lang: $lang)
                    .environmentObject(userStore)
                    .environmentObject(authVM),
                isActive: $authVM.isUserSave
            ) {
                EmptyView()
            }
            .hidden()
            
        }
        .onAppear {
            // Update selected address from AddressViewModel on reappear
            //            if let selectedAddress = addressVM.selectedAddress {
            //                self.selectedAddress = selectedAddress
            //            }
        }
        .padding(.horizontal, 20)
        //                NavigationLink(destination: MainScreen(userStore: userStore, lang: $lang)
        //                    .environmentObject(userStore),
        //                               isActive: $isSkip) {
        //                        EmptyView()
        //                    }
        //                    .hidden()
        // NavigationLink to MainScreen for skip action
        NavigationLink(
            destination: MainScreen(lang: $lang)
                .environmentObject(userStore)
                .environmentObject(authVM),
            isActive: $isSkip
        ) {
            EmptyView()
        }
        .hidden()
        .navigationBarHidden(true)
    }
    
    func validateAndSaveUserInfo() {
        isNameEmpty = textName.isEmpty
        isPhoneNumberEmpty = phoneNumber.isEmpty
        //           isAddressEmpty = addressVM.selectedAddress == nil
        
        if isNameEmpty || isPhoneNumberEmpty || isAddressEmpty || isPhoneNumberInvalid {
            return
        }
        
        isLoading = true
        authVM.saveUserInfo(
            email: userStore.user?.email ?? "No Email",
            userName: textName,
            phoneNumber: phoneNumber,
            address: userInputAddress,
            accessToken: userStore.user?.accesstoken ?? "",
            refreshToken: userStore.user?.refreshtoken ?? ""
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            authVM.isUserSave = true
        }
    }
}

#Preview {
    UserBasicInfoView(lang: .constant("en"))
}
