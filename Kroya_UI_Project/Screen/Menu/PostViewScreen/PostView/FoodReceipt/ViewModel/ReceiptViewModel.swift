//
//  ReceiptViewModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 13/10/24.
//

import SwiftUI

class ReceiptViewModel: ObservableObject {
    @Published var receipt: Receipt
    
    // Initialize with default values for now
    init() {
        self.receipt = Receipt(
            item: "Somlor Kari",
            referenceNumber: "828200000",
            orderDate: "04/05/2023 @01:39 PM",
            paidBy: "KHQR",
            payer: "Sambat Ratanak",
            sellerName: "Monika Souch",
            sellerPhone: "(+85512383030)",
            amount: "2.20 USD",
            paidTo: "Paid to Monika Souch"
        )
    }
    
    // other logic
}
