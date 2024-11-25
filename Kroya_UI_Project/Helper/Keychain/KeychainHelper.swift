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
        var WebillToken: String?
        var parentAccount:String?
        var DeviceToken: String?
    }
    
    enum KeychainKey: String {
        case accessToken
        case refreshToken
        case email
        case fcmToken
        case WebillToken
        case webillClientId
        case webillSecretId
        case parentAccount
        case DeviceToken
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
    func getDeviceToken() -> Credentials {
        return Credentials(
            DeviceToken: keychain.string(forKey: KeychainKey.DeviceToken.rawValue)
        )
    }
    
    func setCredentials(accessToken: String, refreshToken: String, email: String) {
        keychain.set(accessToken, forKey: KeychainKey.accessToken.rawValue)
        keychain.set(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
        keychain.set(email, forKey: KeychainKey.email.rawValue)
    }
    // MARK: - WeBill Credentials
    func setWeBillCredentials(clientId: String, secretId: String,webillToken:String?,parentAccount:String) {
        keychain.set(clientId, forKey: KeychainKey.webillClientId.rawValue)
        keychain.set(secretId, forKey: KeychainKey.webillSecretId.rawValue)
        keychain.set(webillToken ?? "", forKey: KeychainKey.WebillToken.rawValue)
        keychain.set(parentAccount, forKey: KeychainKey.parentAccount.rawValue)
    }
    
    func getWeBillCredentials() -> (clientId: String?, secretId: String?, webillToken: String?,parentAccount:String?) {
        let clientId = keychain.string(forKey: KeychainKey.webillClientId.rawValue)
        let secretId = keychain.string(forKey: KeychainKey.webillSecretId.rawValue)
        let webillToken = keychain.string(forKey: KeychainKey.WebillToken.rawValue)
        let parentAccount = keychain.string(forKey: KeychainKey.parentAccount.rawValue)
        return (clientId, secretId, webillToken,parentAccount)
    }
    
    func clearWeBillCredentials() {
        keychain.removeObject(forKey: KeychainKey.webillClientId.rawValue)
        keychain.removeObject(forKey: KeychainKey.webillSecretId.rawValue)
        keychain.removeObject(forKey: KeychainKey.WebillToken.rawValue)
        keychain.removeObject(forKey: KeychainKey.parentAccount.rawValue)
        
    }
    //MARK: Device Set
    func setDeviceToken(DeviceToken:String){
        keychain.set(DeviceToken, forKey: KeychainKey.DeviceToken.rawValue)
    }
    //MARK: Clear Device Token
    func clearDeviceToken() {
        keychain.removeObject(forKey: KeychainKey.DeviceToken.rawValue)
    }
    //MARK: Device Token for Use
    func getDeviceTokenForNotifi() -> String? {
        return getDeviceToken().DeviceToken
    }
    func getParentAccount() -> String? {
        return getWeBillCredentials().parentAccount
    }
    func hasAccessToken() -> Bool {
        return getCredentials().accessToken != nil
    }
    
    func getAccessToken() -> String? {
        return getCredentials().accessToken
    }
    func getAccessTokenWeBill() -> String? {
        return getWeBillCredentials().webillToken
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
