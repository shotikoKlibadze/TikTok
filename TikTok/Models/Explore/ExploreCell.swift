//
//  ExploreCell.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 13.05.22.
//

import Foundation
import UIKit

enum ExploreCell {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
}






