

import SwiftUI
struct DeliveryCardDetailView: View {
    @State private var showAddressSheet = false
    @State private var userInputAddress: String?
    @State private var userInputCity: String?
    @Binding var selectedAddress: Address?
    @StateObject private var profileViewModel = ProfileViewModel()
    @Binding var remark: String?
    
    var body: some View {
        VStack {
            // Title and navigation chevron
            HStack {
                Text("Delivery to")
                    .font(.customfont(.semibold, fontSize: 16))
                Spacer()
                Button(action: {
                    showAddressSheet = true
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .sheet(isPresented: $showAddressSheet) {
                NavigationStack {
                    AddressView(
                        onAddressSelected: { selected in
                            // Handle selected address
                            selectedAddress = selected
                            userInputCity = selectedAddress?.specificLocation
                            userInputAddress = selectedAddress?.addressDetail
                            showAddressSheet = false
                        },
                        isFromEditingProfileView: true
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)
            
            // Delivery information
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .frame(width: 20, height: 20)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(userInputCity ?? "Select your city")
                                .font(.customfont(.medium, fontSize: 16))
                            Text(userInputAddress ?? "Select your address")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                   
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .frame(width: 20, height: 20)
                        VStack(alignment: .leading) {
                            Text("\(profileViewModel.userProfile?.fullName ?? "Recipient"), \(profileViewModel.userProfile?.phoneNumber ?? "No phone")")
                                .font(.customfont(.medium, fontSize: 16))
                        }
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // Remarks and notes
            HStack {
                Text(LocalizedStringKey("Remarks"))
                    .font(.customfont(.medium, fontSize: 16))
                TextField(LocalizedStringKey("Notes (optional)"), text: Binding(
                    get: { remark ?? "" },
                    set: { remark = $0.isEmpty ? nil : $0 }
                ))
                .font(.customfont(.medium, fontSize: 16))
                .foregroundColor(remark == nil ? .gray : .primary)
            }
            .padding(.horizontal)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundColor(Color(red: 0.836, green: 0.876, blue: 0.922)),
                alignment: .top
            )
        }
        .onAppear{
            profileViewModel.fetchUserProfile()
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.836, green: 0.876, blue: 0.922), lineWidth: 1.5)
        )
    }
}
