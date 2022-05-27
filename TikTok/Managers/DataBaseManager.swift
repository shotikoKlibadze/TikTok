//
//  DataBaseManager.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init () {}
    
    public func insertUser(email: String, username: String, completion: @escaping (Bool) -> Void) {
        // get current users key
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapShot in
            guard var usersDict = snapShot.value as? [String: Any] else {
                //Create roosers root
                self?.database.child("users").setValue(
                    [
                        username: [
                            "email" : email
                        ]
                    ]) { error, _ in
                        completion(error == nil)
                    }
                return
            }
            //save new users
            usersDict[username] = ["email" : email]
            self?.database.child("users").setValue(usersDict) { error, _ in
                completion(error == nil)
            }
        }
    }
    
    public func getAllUsers() {
        
    }
    
}
