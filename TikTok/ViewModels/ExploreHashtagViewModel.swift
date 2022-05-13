//
//  ExploreHashtagViewModel.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 13.05.22.
//

import Foundation
import UIKit

struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int //Number of post associated with the Hashtag
    let handler: (() -> Void)
}
