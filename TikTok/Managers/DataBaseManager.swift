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
    
    public func getUsername(for email: String, completion: @escaping (String?) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapShot in
            guard let users = snapShot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            
            for (username, value) in users {
                if value["email"] as? String == email {
                    completion(username)
                    break
                }
            }
        }
    }
    
    public func insertPost(fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            if var posts = value["posts"] as? [String] {
                posts.append(fileName)
                value["posts"] = posts
                self?.database.child("users").child(username).setValue(value, withCompletionBlock: { error, _ in
                   completion(error == nil)
                })
            } else {
                value["posts"] = [fileName]
                self?.database.child("users").child(username).setValue(value, withCompletionBlock: { error, _ in
                   completion(error == nil)
                })
            }
        }
    }
    
    public func getAllUsers() {
        
    }
    
}
