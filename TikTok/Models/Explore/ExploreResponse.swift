//
//  ExploreResponse.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 13.05.22.
//

import Foundation

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}
