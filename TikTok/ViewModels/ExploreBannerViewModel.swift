//
//  ExploreBannerViewModel.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 13.05.22.
//

import Foundation
import UIKit

struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}
