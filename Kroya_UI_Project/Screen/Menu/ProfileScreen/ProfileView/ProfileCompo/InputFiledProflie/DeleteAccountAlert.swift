import SwiftUI

struct DeleteAccountBottomSheetView: View {
    @State private var showBottomSheet = false

    var body: some View {
        ZStack {
            VStack {
                //  main content
                Text("Main Content")
                    .font(.customfont(.semibold, fontSize: 22))
                    .padding()

                Spacer()

                // Button to show the BottomSheet
                Button(action: {
                    showBottomSheet.toggle()
                }) {
                    Text("Delete Account")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                }
                .padding()
            }

            // Bottom Sheet View
            if showBottomSheet {
                VStack {
                    Spacer()

                    // The sheet content
                    VStack(spacing: 20) {
                        Capsule()
                            .frame(width: 40, height: 5)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                        HStack{
                            Image(systemName: "trash.fill")
                            Text("Delete your account")
                                .font(.customfont(.medium, fontSize: 22))
                                //.padding(.top, 10)
                        }

                        // Delete Button
                        Button(action: {
                            // Handle account deletion logic here
                            showBottomSheet.toggle()
                            print("Account Deleted")
                        }) {
                            Text("Delete")
                                .foregroundColor(.white)
                                .font(.customfont(.bold, fontSize: 16))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                        }

                        // Cancel Button
                        Button(action: {
                            showBottomSheet.toggle()
                        }) {
                            Text("Cancel")
                                .foregroundColor(.black)
                                .font(.customfont(.bold, fontSize: 16))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                        }
                        Spacer()
                    }
                    .frame(height: UIScreen.main.bounds.height / 4 * 1.2) // 1/4 of the screen height
                    .background(Color(hex: "#F3F5F7"))
                    .cornerRadius(20)
                   // .shadow(radius: 1)
                    .transition(.move(edge: .bottom))
                  
                }
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut)
            }
        }
    }
}

#Preview {
    DeleteAccountBottomSheetView()
}
