//
//  KeychainHelper.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 16/10/24.
//

import Foundation
import SwiftKeychainWrapper

class Auth: ObservableObject {
    
    struct Credentials {
        var accessToken: String?
        var refreshToken: String?
        var email: String?
    }
    
    enum KeychainKey: String {
        case accessToken
        case refreshToken
        case email
    }
    
    static let shared: Auth = Auth()
    private let keychain: KeychainWrapper = KeychainWrapper.standard
    private var refreshTimer: DispatchSourceTimer?
    
    @Published var loggedIn: Bool = false
    
    private init() {
        loggedIn = hasAccessToken()
    }
    
    func getCredentials() -> Credentials {
        return Credentials(
            accessToken: keychain.string(forKey: KeychainKey.accessToken.rawValue),
            refreshToken: keychain.string(forKey: KeychainKey.refreshToken.rawValue),
            email: keychain.string(forKey: KeychainKey.email.rawValue)
        )
    }
    
    func setCredentials(accessToken: String, refreshToken: String, email: String)  {
        keychain.set(accessToken, forKey: KeychainKey.accessToken.rawValue) 
        keychain.set(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
        keychain.set(email, forKey: KeychainKey.email.rawValue)
        
        loggedIn = true
//        startTokenRefreshTimer()
    }
    
    func hasAccessToken() -> Bool {
        return getCredentials().accessToken != nil
    }
    
    func getAccessToken() -> String? {
        return getCredentials().accessToken
    }

    func getRefreshToken() -> String? {
        return getCredentials().refreshToken
    }

    func logout() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.refreshToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.email.rawValue)
        loggedIn = false
    }
    
//    // Start a countdown to refresh the token 5 seconds before expiration
//    func startTokenRefreshTimer() {
//        refreshTimer?.cancel() // Cancel any existing timer
//        
//        // Set the timer for 55 seconds (to refresh before 60 seconds token expiration)
//        let timerInterval: TimeInterval = 55
//        
//        refreshTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
//        refreshTimer?.schedule(deadline: .now() + timerInterval, repeating: .never)
//        
//        refreshTimer?.setEventHandler { [weak self] in
//            print("Token is about to expire, refreshing token...")
//            self?.refreshAccessToken { success in
//                if success {
//                    print("Token refreshed successfully!")
//                } else {
//                    print("Token refresh failed.")
//                }
//            }
//        }
//        
//        refreshTimer?.resume() // Start the timer
//    }
    
//    // Refresh the access token by calling the login API with the stored credentials
//    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
//        let credentials = getCredentials()
//        guard let email = credentials.email, let password = credentials.password else {
//            print("Missing email or password for token refresh.")
//            completion(false)
//            return
//        }
//        
//        // Call the login endpoint to refresh tokens
//        AuthService.shared.LoginAccount(email: email, password: password) { result in
//            switch result {
//            case .success(let tokens):
//                self.setCredentials(accessToken: tokens.payload?.access_token ?? "", refreshToken: tokens.payload?.refresh_token ?? "", email: email, password: password)
//                completion(true)
//            case .failure(let error):
//                print("Failed to refresh token via login: \(error)")
//                completion(false)
//            }
//        }
//    }
}
