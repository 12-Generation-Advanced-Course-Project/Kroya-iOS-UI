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
    @EnvironmentObject var addressVM: AddressViewModel
    @ObservedObject var authVM = AuthViewModel(userStore: UserStore())
    @Binding var lang:String
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
                    } else {
                        Text("")
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    }
                   
                }
                //MARK: Phone Number
                VStack(alignment: .leading, spacing: 5) {
                    Text("Phone Number")
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
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    } else if isPhoneNumberInvalid {
                        Text("Phone number can only contain digits")
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    } else {
                        Text("")
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    }
                    
                }
                //MARK: Address
                VStack(alignment: .leading, spacing: 5) {
                    Text("Address")
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.gray)
                    NavigationLink(destination: AddressView(viewModel: addressVM)) {
                        HStack {
                            Image("pinmap")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                            Text(selectedAddress?.specificLocation ?? "Select Address")
                                .font(.customfont(.regular, fontSize: 18))
                                .padding(.vertical, 20)
                                .foregroundColor(.gray)
                                .keyboardType(.default)
                                .frame(width: .screenWidth * 0.6, alignment: .leading)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .background(Color(hex: "#F2F2F7"))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .frame(height: 60)
                    }
                    .onChange(of: selectedAddress) { newValue in
                        isAddressEmpty = newValue == nil
                    }
                    
                    if isAddressEmpty {
                        Text("Please select an address")
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    } else {
                        Text("")
                            .foregroundColor(.red)
                            .font(.customfont(.medium, fontSize: 14))
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity,maxHeight: .screenHeight * 0.4)
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
            Button(action: {
                isSkip.toggle()
                Auth.shared.loggedIn = true
               
            }) {
                Text("Skip")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundColor(PrimaryColor.normal)
            }

            Spacer()
            NavigationLink(destination:  MainScreen(userStore: userStore,lang:$lang).environmentObject(userStore),isActive: $authVM.isUserSave, label: {
                EmptyView()
            })
            .hidden()
        }
        .padding(.horizontal, 20)
        .navigationDestination(isPresented: $isSkip, destination: {
            MainScreen(userStore: userStore,lang:$lang).environmentObject(userStore).navigationBarHidden(true)
        })
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

