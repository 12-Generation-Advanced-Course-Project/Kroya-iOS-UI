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
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var successMessage: String = ""
    @Published var errorMessage: String = ""

    // Load WeBill Account
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
                print("Loaded WeBill account for email: \(email)")
            } else {
                print("No WeBill account found for email \(email).")
            }
        } catch {
            print("Failed to load WeBill account: \(error)")
        }
    }

    // Save WeBill Account
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
                print("Updated WeBill account for email: \(email)")
            } else {
                // Create new account
                let newAccount = WeBillAccount(email: email, clientId: self.clientID, secretId: self.clientSecret)
                context.insert(newAccount)
                print("Created new WeBill account for email: \(email)")
            }
            // Save changes
            try context.save()
        } catch {
            print("Failed to save WeBill account: \(error)")
        }
    }

    // Clear WeBill Account
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
        } catch {
            print("Failed to clear WeBill account: \(error)")
        }
    }

    // MARK: - WeBill365 AccessToken
    func fetchWeBillAccessToken(context: ModelContext, completion: @escaping (Bool) -> Void) {
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
        BankService.shared.weBill365Token(clientID: clientID, clientSecret: clientSecret) { [weak self] result in
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
}
