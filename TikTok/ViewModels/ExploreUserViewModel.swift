//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 13.05.22.
//

import Foundation
import UIKit

struct ExploreUserViewModel {
    let profilePic: UIImage?
    let userName: String
    let followerCount: Int
    let handler: (() -> Void)
}
