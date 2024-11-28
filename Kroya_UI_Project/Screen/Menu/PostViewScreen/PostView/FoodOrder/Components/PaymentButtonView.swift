//
//  PaymentButtonView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

struct PaymentButtonView: View {
    @State private var isShowingQRModal = false
    @State private var selectedPaymentMethod: String? = nil
    @Binding var payment: String
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var WeBillVM = WeBill365ViewModel()
    @ObservedObject var PurchaesViewModel: OrderViewModel
    @StateObject private var User = UserStore()
    @Environment(\.modelContext) private var context
    var amount: Int
    var remark: String
    var Location:String
    var Qty:Int
    var FoodSellId:Int
    @State private var responseCredientail : SellerCredentials?
    var body: some View {
        HStack(spacing: 10) {
            // Pay with cash button
            Button(action: {
                selectedPaymentMethod = "CASH"
                payment = "CASH"
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    Text(LocalizedStringKey("Pay with cash"))
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.995, green: 0.969, blue: 0.852))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedPaymentMethod == "CASH" ? Color.yellow : Color(red: 0.962, green: 0.941, blue: 0.854), lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Pay with KHQR button
            Button(action: {
                selectedPaymentMethod = "KHR"
                payment = "KHR"
                let PaymentType = "1"
                BankService.shared.getSellerCredientail(sellerId: FoodSellId) { result in
                    switch result {
                    case .success(let sellerCredentials):
//                        print("Seller Credentials: \(sellerCredentials)")
                        BankService.shared.weBill365Token(clientID: sellerCredentials.payload.clientID, clientSecret: sellerCredentials.payload.clientSecret , parentAccount: sellerCredentials.payload.accountNo) {  result in
                            switch result {
                            case .success(_):
                                
                                let QRCollectionRequest = QRCollectionRequest(
                                                    payername: profileVM.userProfile?.fullName ?? "",
                                                    parentAccountNo: sellerCredentials.payload.accountNo,
                                                    paymentType: PaymentType,
                                                    currencyCode: payment,
                                                    amount: amount,
                                                    remark: remark
                                                )
                                WeBillVM.fetchQRCollection(request: QRCollectionRequest) { billNo in
                                                    guard let billNo = billNo else {
                                                        print("Failed to generate QR or missing BillNo.")
                                                        isShowingQRModal = false
                                                        return
                                                    }
                                                    isShowingQRModal = true
                                                    print("Starting QR status polling for BillNo: \(billNo)")
                                                    WeBillVM.startPollingQRStatus(billNo: WeBillVM.qrCollectionData?.billNo ?? "")
                                
                                                    //MARK: Wait 10 Sec then Request Purchase
                                                    let purchase = PurchaseRequest(
                                                        foodSellId: FoodSellId,
                                                        remark: remark,
                                                        location: Location,
                                                        quantity: Qty,
                                                        totalPrice: Double(amount)
                                                    )
                                
                                                    // Debug: Print the details for verification
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                                        print("PurchaesRequest: \(purchase)")
                                                        PurchaesViewModel.addPurchase(purchase: purchase, paymentType: "KHQR")
                                                        WeBillVM.stopPolling()
                                                    
                                                    }
                                                }
//                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                                                    isShowingQRModal = true
//                                                }
                                
                                break
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                                // Handle error   
                            }
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        // Handle error
                    }
                }
               
                
                
//                guard let parentAccount = Auth.shared.getParentAccount() else {
//                    let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
//                    return
//                }
//                let QRCollectionRequest = QRCollectionRequest(
//                    payername: profileVM.userProfile?.fullName ?? "",
//                    parentAccountNo: parentAccount,
//                    paymentType: PaymentType,
//                    currencyCode: payment,
//                    amount: amount,
//                    remark: remark
//                )
//                
//                print("QRCollectionRequest: \(QRCollectionRequest)")
//                
//                WeBillVM.fetchQRCollection(request: QRCollectionRequest) { billNo in
//                    guard let billNo = billNo else {
//                        print("Failed to generate QR or missing BillNo.")
//                        return
//                    }
//                    print("Starting QR status polling for BillNo: \(billNo)")
//                    WeBillVM.startPollingQRStatus(billNo: WeBillVM.qrCollectionData?.billNo ?? "")
//                    
//                    //MARK: Wait 10 Sec then Request Purchase
//                    let purchase = PurchaseRequest(
//                        foodSellId: FoodSellId,
//                        remark: remark,
//                        location: Location,
//                        quantity: Qty,
//                        totalPrice: Double(amount)
//                    )
//                    
//                    // Debug: Print the details for verification
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                        print("PurchaesRequest: \(purchase)")
//                        PurchaesViewModel.addPurchase(purchase: purchase, paymentType: "KHQR")
//                        WeBillVM.stopPolling()
                    
//                    }
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    isShowingQRModal = true
//                }
//                isShowingQRModal = true
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image("khqr")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Image("webill365_logo_full 1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 15)
                        Spacer()
                    }
                    Text(LocalizedStringKey("Pay with KHQR"))
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedPaymentMethod == "KHR" ? Color.yellow : Color(red: 0.836, green: 0.875, blue: 0.924), lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle()) // Remove default button style
            .sheet(isPresented: $isShowingQRModal) {
                PaywithKHQRModalView(khqrData: WeBillVM.qrCollectionData?.khqrdata ?? "")
                    .presentationDetents([.fraction(0.70)])
                    .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            profileVM.fetchUserProfile()
            WeBillVM.loadWeBillAccount(context: context)
        }
    }
}
