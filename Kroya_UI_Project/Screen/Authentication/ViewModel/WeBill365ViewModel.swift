//
//  WeBill365ViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 21/11/24.
//
// WeBill365ViewModel.swift

import SwiftData
import SwiftUI

class WeBill365ViewModel: ObservableObject {
    @Published var clientID: String = ""
    @Published var clientSecret: String = ""
    @Published var accountNumber: String = ""
    @Published var parentAccountNo: String = ""
    @Published var WebillAccount: ConnectWebillConnect?
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var successMessage: String = ""
    @Published var errorMessage: String = ""
    @Published var qrCollectionData: DataForQRCollection? = nil
    @Published var qrCollectionStatus: Status? = nil
    @Published var isChecktrue: Bool = false
    @Published var isConnect: Bool = false
    private var pollingTimer: Timer?
    // MARK: - Load WeBill Account
    func loadWeBillAccount(context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot load WeBill account.")
            return
        }
        let predicate = #Predicate<WeBillAccount> { $0.email == email }
        let fetchDescriptor = FetchDescriptor<WeBillAccount>(predicate: predicate)
        do {
            let results = try context.fetch(fetchDescriptor)
            if let account = results.first {
                self.clientID = account.clientId
                self.clientSecret = account.secretId
                self.parentAccountNo = account.parentAccountNo
                print("Loaded WeBill account for email: \(email)")
            } else {
                print("No WeBill account found for email \(email).")
            }
        } catch {
            print("Failed to load WeBill account: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Save WeBill Account
    func saveWeBillAccount(context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot save WeBill account.")
            return
        }
        let predicate = #Predicate<WeBillAccount> { $0.email == email }
        let fetchDescriptor = FetchDescriptor<WeBillAccount>(predicate: predicate)
        do {
            let results = try context.fetch(fetchDescriptor)
            if let existingAccount = results.first {
                // Update existing account
                existingAccount.clientId = self.clientID
                existingAccount.secretId = self.clientSecret
                existingAccount.parentAccountNo = self.parentAccountNo
                print("Updated WeBill account for email: \(email)")
            } else {
                // Create new account
                let newAccount = WeBillAccount(parentAccountNo: parentAccountNo, email: email, clientId: self.clientID, secretId: self.clientSecret)
                context.insert(newAccount)
                print("Created new WeBill account for email: \(email)")
            }
            // Save changes
            try context.save()
        } catch {
            print("Failed to save WeBill account: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Clear WeBill Account
    func clearWeBillAccount(context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot clear WeBill account.")
            return
        }
        let predicate = #Predicate<WeBillAccount> { $0.email == email }
        let fetchDescriptor = FetchDescriptor<WeBillAccount>(predicate: predicate)
        do {
            let results = try context.fetch(fetchDescriptor)
            for account in results {
                context.delete(account)
                print("Deleted WeBill account for email: \(email)")
            }
            // Save changes
            try context.save()
            self.clientID = ""
            self.clientSecret = ""
            self.parentAccountNo = ""
        } catch {
            print("Failed to clear WeBill account: \(error.localizedDescription)")
        }
    }
    
    // MARK: - WeBill365 AccessToken
    func fetchWeBillAccessToken(context: ModelContext,completion: @escaping (Bool) -> Void) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot fetch WeBill access token.")
            self.errorMessage = "User not logged in."
            self.showError = true
            completion(false)
            return
        }
        
        guard !clientID.isEmpty, !clientSecret.isEmpty else {
            self.errorMessage = "Client ID and Secret ID cannot be empty."
            self.showError = true
            completion(false)
            return
        }
        
        self.isLoading = true
        BankService.shared.weBill365Token(clientID: clientID, clientSecret: clientSecret, parentAccount: parentAccountNo) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success():
                    print("Access token retrieved and saved successfully.")
                    self?.saveWeBillAccount(context: context)
                    self?.successMessage = "Access token retrieved and saved successfully."
                    completion(true)
                case .failure(let error):
                    print("Failed to retrieve access token: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Fetch QR Collection
    func fetchQRCollection(request: QRCollectionRequest, completion: @escaping (String?) -> Void) {
        self.isLoading = true
        BankService.shared.QRCollection(QRCollectionRequest: request) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let qrCollection):
                    self?.qrCollectionData = qrCollection.data
                    self?.qrCollectionStatus = qrCollection.status
                    self?.successMessage = qrCollection.status?.message ?? ""
                    print("QR Collection fetched successfully: \(String(describing: qrCollection.data))")
                    completion(qrCollection.data?.billNo) // Pass the BillNo to the callback
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isChecktrue = false
                    print("Failed to fetch QR collection: \(error.localizedDescription)")
                    completion(nil) // Indicate failure
                }
            }
        }
    }
    
    // MARK: - Check QR Status
    func CheckStatusQR(billNo: String) {
        let request = CheckStatusCodeRequest(billNo: [billNo])
        
        self.isLoading = true
        BankService.shared.QRCheckStatus(QrcheckStatus: request) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let qrStatusResponse):
                    if let status = qrStatusResponse.status, status.code == 200 {
                        self?.qrCollectionStatus = status
                        self?.successMessage = "QR payment completed successfully."
                        self?.isChecktrue = true
                        self?.stopPolling() // Stop polling on success
                        print("QR Status success: \(String(describing: qrStatusResponse.data))")
                    } else {
                        self?.errorMessage = qrStatusResponse.status?.message ?? "Unknown error"
                        print("QR Status pending or failed: \(self?.errorMessage ?? "Unknown error")")
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to fetch QR status: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Poll QR Status
    func startPollingQRStatus(billNo: String) {
        stopPolling() // Ensure no duplicate timers
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.CheckStatusQR(billNo: billNo)
        }
    }
    
    func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    // MARK: - Connect WeBill
    func ConnectWeBillAccount(ConnectRequest: ConnectWebillConnectRequest, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        BankService.shared.connectWeBill(request: ConnectRequest) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ConnectResponse):
                    if ConnectResponse.statusCode == "200", let payload = ConnectResponse.payload {
                        // Successfully connected
                        self?.WebillAccount = payload
                        self?.isConnect = true
                        print("WeBill connected successfully: \(payload)")
                        completion(true)
                    } else if ConnectResponse.statusCode == "409" {
                        // Handle already connected scenario
                        self?.isConnect = true
                        self?.successMessage = "Account is already connected."
                        print("Account already connected. Status code 409.")
                        completion(true)
                    } else {
                        // Handle other unsuccessful scenarios
                        self?.errorMessage = ConnectResponse.message
                        print("Connect WeBill failed: \(self?.errorMessage ?? "Unknown error")")
                        completion(false)
                    }
                case .failure(let error):
                    // Handle request failure
                    self?.errorMessage = error.localizedDescription
                    print("Failed to connect WeBill: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }



    //MARK: Get Credentail WeBill
    func fetchWeBillAccount(SellerId: Int) {
        self.isLoading = true
        BankService.shared.getWeBillAccountCredential(SellerId: SellerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if let payload = response.payload {
                        self?.WebillAccount = payload
                        print("Fetched WeBill account details: \(payload)")
                    } else {
                        self?.errorMessage = response.message
                        print("Error: \(self?.errorMessage ?? "Unknown error")")
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to fetch WeBill account details: \(error.localizedDescription)")
                }
            }
        }
    }
    // MARK: - Disconnect WeBill Account
    func DisconnectWeBillaccount(context: ModelContext) {
        self.isLoading = true // Show loading indicator
        
        BankService.shared.disConnectWeBillAccount { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false // Stop loading indicator
                
                switch result {
                case .success(let response):
                    print("WeBill Disconnected Successfully: \(response.message)")
                    self?.successMessage = "WeBill Disconnected Successfully"
                    self?.clearWeBillAccount(context: context)
                    self?.isConnect = false
                case .failure(let error):
                    print("Failed to Disconnect WeBill: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to Disconnect WeBill: \(error.localizedDescription)"
                    self?.showError = true
                }
            }
        }
    }

    func connectWeBill() {
        let connectRequest = ConnectWebillConnectRequest(clientId: clientID, clientSecret: clientSecret, accountNo: parentAccountNo)
        ConnectWeBillAccount(ConnectRequest: connectRequest) { success in
            DispatchQueue.main.async {
                if success {
                    self.isConnect = true
                    UserDefaults.standard.set(true, forKey: "isWeBillConnected")
                } else {
                    // Handle failure case
                    self.isConnect = false
                }
            }
        }
    }

    // This is just an example, replace it with the actual function or connection logic
    func someConnectionFunction(completion: @escaping (Bool) -> Void) {
       
        DispatchQueue.global().async {
            // Simulate a success after some delay
            sleep(2)
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }

    // Function to load the persisted connection status when the app starts
       func loadConnectionStatus() {
           if let savedStatus = UserDefaults.standard.value(forKey: "isWeBillConnected") as? Bool {
               self.isConnect = savedStatus
           }
       }

       // Disconnect function (example)
       func disconnectWeBill() {
           self.isConnect = false
           // Remove connection status from UserDefaults
           UserDefaults.standard.removeObject(forKey: "isWeBillConnected")
       }

    
}
