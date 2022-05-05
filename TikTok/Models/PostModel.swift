//
//  PostModel.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import Foundation

struct PostModel {
    
    let identifier : String
    var isLikedByCurrentUser = false
    
    let user = User(userName: "kane", profilePicgureURL: nil, identifier: UUID().uuidString)
    
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...10 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
