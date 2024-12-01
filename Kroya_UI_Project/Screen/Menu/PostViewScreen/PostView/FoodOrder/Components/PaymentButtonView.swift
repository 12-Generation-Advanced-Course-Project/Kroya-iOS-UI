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
    @ObservedObject  var WeBillVM : WeBill365ViewModel
    @ObservedObject var PurchaesViewModel: OrderViewModel
    @StateObject private var User = UserStore()
    @Environment(\.modelContext) private var context
    var amount: Int
    var remark: String
    var Location: String
    var Qty: Int
    var SellerId: Int
    var SellerName: String
    var ParentAccountFromSeller: String
    var ClientId: String
    var SecretId: String
    var FoodId:Int
    @State private var responseCredientail: SellerCredentials?
    @Binding var isNoConnectWeBill: Bool
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
                
                let currentDateTime = getCurrentDateTime()
                let QuickBills = QuickBillsRequest(
                    accountName: SellerName,
                    paymentType: PaymentType,
                    currencyCode: payment,
                    issueDatetime: currentDateTime,
                    paymentTerm: "7",
                    parentAccountNo: ParentAccountFromSeller,
                    amount: amount,
                    remark: remark
                )
                print("QuickBills Request: \(QuickBills)")
                
                BankService.shared.weBill365TokenFromSeller(clientID: ClientId, clientSecret: SecretId) { success in
                    guard success else {
                        print("Failed to retrieve token from seller.")
                        isNoConnectWeBill = true
                        return
                    }
                    
                    WeBillVM.QuickBillsWebill(request: QuickBills) { billNo in
                        guard let billNo = billNo else {
                            print("Failed to generate QR or missing BillNo.")
                            return
                        }
                        print("Starting QR status polling for BillNo: \(billNo)")
                        
                        // Start polling for QR status
                        WeBillVM.startPollingQRStatus(billNo: billNo) { isSuccess in
                            if isSuccess {
                                // If QR payment is successful, proceed with purchase
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    let purchase = PurchaseRequest(
                                        foodSellId: FoodId,
                                        remark: remark,
                                        location: Location,
                                        quantity: Qty,
                                        totalPrice: Double(amount)
                                    )
                                    print("Purchase Request: \(purchase)")
                                    PurchaesViewModel.addPurchase(purchase: purchase, paymentType: "KHQR")
                                    WeBillVM.stopPolling()
                                }
                            } else {
                                print("QR payment failed or still pending.")
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isShowingQRModal = true
                    }
                }
                
               
              
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
            .buttonStyle(PlainButtonStyle())
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
    
    // MARK: Helper Function for Current DateTime
    private func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: Date())
    }

}
