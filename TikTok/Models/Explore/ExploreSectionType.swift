//
//  ExploreSectionType.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 13.05.22.
//

import Foundation

enum ExploreSectonType : CaseIterable {
    
    case banners
    case trendingPosts
    case users
    case trendingHashtags
   // case recomended
    case popular
    case new
    
    var title : String {
        switch self {
        case .banners:
            return "Featured"
        case .trendingPosts:
            return "Trending Videos"
        case.users:
            return "Popular Creators"
        case .trendingHashtags:
            return "Hashtags"
//        case .recomended:
//            return "Recomended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"
        }
    }
}
