//
//  ExploreManager.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 13.05.22.
//

import Foundation
import UIKit

protocol ExploreManagerDelegate: AnyObject {
    func pushViewController(_ vc: UIViewController)
}

final class ExploreManager {
    
    static let shared = ExploreManager()
    
    weak var delegate: ExploreManagerDelegate?
    
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.banners.compactMap({ExploreBannerViewModel(image: UIImage(named: $0.image), title: $0.title) {
            
        }})
    }
    
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.creators.compactMap({ ExploreUserViewModel(profilePic: UIImage(named: $0.image), userName: $0.username, followerCount: $0.followers_count) {
            
        } })
    }
    
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.hashtags.compactMap({ExploreHashtagViewModel(text: $0.tag, icon: UIImage(systemName: $0.image), count: $0.count) {
            
        }})
    }
    
    public func getEploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.trendingPosts.compactMap({ExplorePostViewModel(thumbnailImage: UIImage(named: $0.image), caption: $0.caption) {
            
        }})
    }
    
    public func getEploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.recentPosts.compactMap({ExplorePostViewModel(thumbnailImage: UIImage(named: $0.image), caption: $0.caption) {
            
        }})
    }
    
    public func getEplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.popular.compactMap({ExplorePostViewModel(thumbnailImage: UIImage(named: $0.image), caption: $0.caption) {
            
        }})
    }
    
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            print("nojSON")
            return nil
        }
        do{
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ExploreResponse.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}

