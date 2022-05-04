//
//  StorageManager.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    public static let shared = StorageManager()
    
    private let database = Storage.storage().reference()
    
    private init () {}
    
    public func getVideoURL() {
        
    }
    
    public func uploadVideoURL() {
        
    }
}
