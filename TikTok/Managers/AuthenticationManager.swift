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
    
    enum AuthError : Error {
        case signInFailed
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    private init () {}
    
    public func signIn(with email: String, password: String, completion: @escaping (Result<String,Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let _ = result , error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            DatabaseManager.shared.getUsername(for: email) { username in
                if let username = username {
                    UserDefaults.standard.set(username, forKey: "username")
                    print("gotUserName \(username)")
                }
            }
            //succesfull sign in
            completion(.success(email))
        }
    }
    
    public func signUp(with userName: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        //Make sur usernaame is available
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let _ = result , error == nil else {
                completion(false)
                return
            }
            UserDefaults.standard.set(userName, forKey: "username")
            DatabaseManager.shared.insertUser(email: email, username: userName, completion: completion)
        }
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
