//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 13.05.22.
//

import Foundation

struct ExploreUserViewModel {
    let profilePicURL: URL?
    let userName: String
    let followerCount: Int
    let handler: (() -> Void)
}
