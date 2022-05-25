//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    public static let shared = AuthManager()
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    private init () {}
    
    public func signIn(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func signUp(with userName: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
       
    }
    
    
}
