//
//  PostComment.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 05.05.22.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(userName: "West", profilePicgureURL: nil, identifier: UUID().uuidString)
        return [
            PostComment(text: "very good video", user: user, date: Date()),
            PostComment(text: "very good video", user: user, date: Date()),
            PostComment(text: "very good video", user: user, date: Date()),
            PostComment(text: "very good video", user: user, date: Date()),
            PostComment(text: "very good video", user: user, date: Date()),
            PostComment(text: "very good video", user: user, date: Date()),
            PostComment(text: "very good video", user: user, date: Date())
        ]
    }
}
