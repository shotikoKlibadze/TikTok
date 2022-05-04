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
    
    public func getAllUsers() {
        
    }
    
}
