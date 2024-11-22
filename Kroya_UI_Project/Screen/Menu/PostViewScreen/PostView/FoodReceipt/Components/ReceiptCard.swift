//
//  ReceiptCard.swift
//  Kroya
//
//  Created by KAK-LY on 17/10/24.
//

import SwiftUI
import Photos
import SDWebImageSwiftUI
struct ReceiptCard: View {
    @ObservedObject var viewModel: ReceiptViewModel
    @StateObject private var ReceiptVM = OrderViewModel()
    @StateObject private var Profile = ProfileViewModel()
    @Binding var presentPopup: Bool
    @State private var downloadSuccess: Bool = false
    @State private var isImageLoaded: Bool = false
    var isOrderReceived: Bool
    var FoodSellId:Int
    var body: some View {
        VStack {
            ZStack {
                // Only capture this section
                Image("receipt")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 550)
                    .padding(.horizontal)
                
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        if let FoodSellImage = Profile.userProfile?.profileImage, !FoodSellImage.isEmpty,
                           let imageUrl = URL(string: Constants.fileupload + FoodSellImage) {
                            WebImage(url: imageUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                        } else {
                            Image("user-profile") // Placeholder image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        //MARK: Price and Paid to Seller
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(ReceiptVM.Purchases?.totalPrice ?? 0, specifier: "%.2f") USD")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack {
                                if isOrderReceived {
                                    Image(systemName: "arrow.down.left")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(.green)
                                    
                                    Text("Paid to \(ReceiptVM.Purchases?.seller ?? "Unknown")")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                } else {
                                    Image(systemName: "arrow.up.right")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(.red)
                                    
                                    Text("\(ReceiptVM.Purchases?.payer ?? "Unknown")")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.leading, 20)
                    .offset(y: -7)
                    //MARK: Item
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text("Item")
                                .opacity(0.7)
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                            Text(ReceiptVM.Purchases?.foodSellCardResponse.name ?? "")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.yellow)
                                .padding(.trailing,14)
                            
                            Spacer()
                            Text("x\(ReceiptVM.Purchases?.quantity ?? 0)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.black)
                        }.padding(.horizontal)
                        Rectangle()
                            .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
                            .frame(height: 1)
                        
                        ReceiptRow(label: "Reference#", value: ReceiptVM.Purchases?.reference ?? "")
                        ReceiptRow(label: "Order Date", value: formatDate(from: ReceiptVM.Purchases?.orderDate ?? ""))
                        ReceiptRow(label: "Paid by", value: ReceiptVM.Purchases?.paidBy ?? "")
                        
                        
                        //MARK: Payer
                        if isOrderReceived {
                            HStack{
                                Text("Payer")
                                    .opacity(0.7)
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(ReceiptVM.Purchases?.payer ?? "")
                                        .font(.system(size: 16, weight: .medium))
                                    // ReceiptRow(label: "Payer", value: viewModel.receipt.payer)
                                    Text(viewModel.receipt.sellerPhone)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.yellow)
                                }
                                Spacer()
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.yellow)
                            } .padding(.horizontal)
                        } else {
                            ReceiptRow(label: "Payer", value: ReceiptVM.Purchases?.payer ?? "")
                        }
                        
                        if isOrderReceived{
                            Rectangle()
                                .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
                                .frame(height: 1)
                        }
                        
                        if isOrderReceived {
                            ReceiptRow(label: "Address", value: viewModel.receipt.address)
                        } else{
                            HStack {
                                Text("Seller")
                                    .opacity(0.7)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(ReceiptVM.Purchases?.foodSellCardResponse.sellerInformation?.fullName ?? "")
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(.trailing,35)
                                    Text("\(ReceiptVM.Purchases?.foodSellCardResponse.sellerInformation?.phoneNumber ?? "")")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                Spacer()
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.yellow)
                            }
                            .padding(.horizontal)
                            Rectangle()
                                .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
                                .frame(height: 1)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Button {
                            saveImage { success in
                                if success {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation(.easeInOut) {
                                            presentPopup = true
                                        }
                                    }
                                    downloadSuccess = true
                                }
                                
                            }
                        } label: {
                            HStack {
                                if !downloadSuccess {
                                    // Show icon only if download not successful
                                    Image(systemName: "arrow.down.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(downloadSuccess ? Color(hex: "#3FBD4E") : .yellow)
                                }
                                
                                Text(downloadSuccess ? "Download Success" : "Download Receipt")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.yellow)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(downloadSuccess)
                    }

                    
                }
            }
            .frame(maxWidth: .infinity, minHeight: 530, alignment: .center)
            
            .background(Color.clear)
        }
        .onAppear{
            ReceiptVM.getReceipt(purchaseId: FoodSellId)
            Profile.fetchUserProfile()
        }
    }
    func saveImage(complete: @escaping (Bool) -> Void) {
          let receiptSize = CGSize(width: UIScreen.main.bounds.width, height: 620)

          self.body.captureUIView(size: receiptSize) { image in
              guard let receiptImage = image else {
                  print("Error capturing receipt image")
                  complete(false)
                  return
              }

              // Save to Photos
              if let pngData = receiptImage.pngData() {
                  PHPhotoLibrary.shared().performChanges({
                      PHAssetChangeRequest.creationRequestForAsset(from: UIImage(data: pngData)!)
                  }) { success, error in
                      if success {
                          print("Receipt saved successfully!")
                          complete(true)
                      } else if let error = error {
                          print("Error saving receipt: \(error.localizedDescription)")
                          complete(false)
                      }
                  }
              } else {
                  print("Error generating PNG data")
                  complete(false)
              }
          }
      }


    // Helper function to capture and save the view
    private func captureAndSave(complete: @escaping (Bool) -> Void) {
        let receiptSize = CGSize(width: UIScreen.main.bounds.width, height: 620)

        self.body.captureUIView(size: receiptSize) { image in
            guard let receiptImage = image else {
                print("Error capturing receipt image")
                complete(false)
                return
            }

            // Save the captured receipt image to Photos
            if let pngData = receiptImage.pngData() {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: UIImage(data: pngData)!)
                }) { success, error in
                    if success {
                        print("Receipt (including WebImage) saved successfully!")
                        DispatchQueue.main.async {
                            self.downloadSuccess = true
                            complete(true)
                        }
                    } else if let error = error {
                        print("Error saving receipt: \(error.localizedDescription)")
                        complete(false)
                    }
                }
            } else {
                print("Error generating PNG data for receipt image")
                complete(false)
            }
        }
    }


    private func downloadAndSaveImage(from url: URL, completion: @escaping (Bool) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading profile image: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to download image: Invalid HTTP response or status code.")
                completion(false)
                return
            }

            guard let mimeType = httpResponse.mimeType, mimeType.starts(with: "image") else {
                print("Invalid MIME type for image")
                completion(false)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Error decoding profile image data")
                completion(false)
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if success {
                    print("Profile image saved successfully!")
                    completion(true)
                } else if let error = error {
                    print("Error saving profile image: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }.resume()
    }

    
    func formatDate(from dateString: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
            guard let date = inputFormatter.date(from: dateString) else {
                return "Invalid Date"
            }
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd/yyyy @hh:mm a"
            return outputFormatter.string(from: date)
        }
    
}
struct ReceiptRow: View {
    var label: String
    var value: String
    var valueColor: Color = .black
    
    var body: some View {
        HStack(spacing: 20) {
            Text(label)
                .opacity(0.7)
                .frame(minWidth: 100, alignment: .leading)
            HStack {
                Text(value)
                    .foregroundColor(valueColor)
            }
        }
        .padding(.horizontal)
        Rectangle()
            .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
            .frame(height: 1)
    }
}

//
struct ReceiptCardForSuccess: View {
    @ObservedObject var viewModel: ReceiptViewModel
    @StateObject private var ReceiptVM = OrderViewModel()
    @StateObject private var Profile = ProfileViewModel()
    @Binding var presentPopup: Bool
    @State private var downloadSuccess: Bool = false
    var isOrderReceived: Bool
    var FoodSellId:Int
    var body: some View {
        VStack {
            ZStack {
                // Only capture this section
                Image("receipt")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 550)
                    .padding(.horizontal)
                
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        if let FoodSellImage = Profile.userProfile?.profileImage, !FoodSellImage.isEmpty,
                           let imageUrl = URL(string: Constants.fileupload + FoodSellImage) {
                            WebImage(url: imageUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                        } else {
                            Image("user-profile") // Placeholder image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        //MARK: Price and Paid to Seller
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(ReceiptVM.Purchases?.totalPrice ?? 0, specifier: "%.2f") USD")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack {
                                if isOrderReceived {
                                    Image(systemName: "arrow.down.left")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(.green)
                                    
                                    Text("Paid to \(ReceiptVM.Purchases?.seller ?? "Unknown")")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                } else {
                                    Image(systemName: "arrow.up.right")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(.red)
                                    
                                    Text("\(ReceiptVM.Purchases?.payer ?? "Unknown")")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.leading, 20)
                    .offset(y: -7)
                    //MARK: Item
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text("Item")
                                .opacity(0.7)
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                            Text(ReceiptVM.Purchases?.foodSellCardResponse.name ?? "")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.yellow)
                                .padding(.trailing,14)
                            
                            Spacer()
                            Text("x\(ReceiptVM.Purchases?.quantity ?? 0)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.black)
                        }.padding(.horizontal)
                        Rectangle()
                            .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
                            .frame(height: 1)
                        
                        ReceiptRow(label: "Reference#", value: ReceiptVM.Purchases?.reference ?? "")
                        ReceiptRow(label: "Order Date", value: formatDate(from: ReceiptVM.Purchases?.orderDate ?? ""))
                        ReceiptRow(label: "Paid by", value: ReceiptVM.Purchases?.paidBy ?? "")
                        
                        
                        //MARK: Payer
                        if isOrderReceived {
                            HStack{
                                Text("Payer")
                                    .opacity(0.7)
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(ReceiptVM.Purchases?.payer ?? "")
                                        .font(.system(size: 16, weight: .medium))
                                    // ReceiptRow(label: "Payer", value: viewModel.receipt.payer)
                                    Text(viewModel.receipt.sellerPhone)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.yellow)
                                }
                                Spacer()
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.yellow)
                            } .padding(.horizontal)
                        } else {
                            ReceiptRow(label: "Payer", value: ReceiptVM.Purchases?.payer ?? "")
                        }
                        
                        if isOrderReceived{
                            Rectangle()
                                .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
                                .frame(height: 1)
                        }
                        
                        if isOrderReceived {
                            ReceiptRow(label: "Address", value: viewModel.receipt.address)
                        } else{
                            HStack {
                                Text("Seller")
                                    .opacity(0.7)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(ReceiptVM.Purchases?.foodSellCardResponse.sellerInformation?.fullName ?? "")
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(.trailing,35)
                                    Text("\(ReceiptVM.Purchases?.foodSellCardResponse.sellerInformation?.phoneNumber ?? "")")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                Spacer()
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.yellow)
                            }
                            .padding(.horizontal)
                            Rectangle()
                                .fill(Color(red: 0.82, green: 0.816, blue: 0.82))
                                .frame(height: 1)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Button {
                        } label: {
                            HStack {
                                Text("Download Success")
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundStyle(PrimaryColor.normal)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(true)
                    }

                    
                }
            }
            .frame(maxWidth: .infinity, minHeight: 530, alignment: .center)
            
            .background(Color.clear)
        }
        .onAppear{
            Profile.fetchUserProfile()
            ReceiptVM.getReceipt(purchaseId: FoodSellId)
        }
    }
 
    func formatDate(from dateString: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
            guard let date = inputFormatter.date(from: dateString) else {
                return "Invalid Date"
            }
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd/yyyy @hh:mm a"
            return outputFormatter.string(from: date)
        }
    
}
