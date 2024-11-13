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
        case fcmToken
    }
    
    static let shared: Auth = Auth()
    let keychain: KeychainWrapper = KeychainWrapper.standard
    private var refreshTimer: DispatchSourceTimer?
    
    @Published var loggedIn: Bool = false
    @Published var isRegistering: Bool = false
    
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
    
    func setCredentials(accessToken: String, refreshToken: String, email: String) {
        keychain.set(accessToken, forKey: KeychainKey.accessToken.rawValue)
        keychain.set(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
        keychain.set(email, forKey: KeychainKey.email.rawValue)
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
    
    //MARK: Save FCM token to Keychain
    func saveFCMToken(_ token: String) {
        keychain.set(token, forKey: KeychainKey.fcmToken.rawValue)
    }
    
    //MARK: Retrieve FCM token from Keychain
    func getFCMToken() -> String? {
        return keychain.string(forKey: KeychainKey.fcmToken.rawValue)
    }
    
    //MARK: Clear FCM token from Keychain
    func clearFCMToken() {
        keychain.removeObject(forKey: KeychainKey.fcmToken.rawValue)
    }
    
    func logout() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.refreshToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.email.rawValue)
        loggedIn = false
        print("User logged out - Logged In Status: \(loggedIn)")
    }
}

//MARK: Extend the Auth class to clear all credentials from Keychain
extension Auth {
    func clearAllCredentials() {
        keychain.removeAllKeys()
        loggedIn = false
        print("Cleared all credentials from Keychain")
    }
    
    //MARK: Check if Token exist
    func isUserLoggedIn() -> Bool {
        return getAccessToken() != nil
    }
}
