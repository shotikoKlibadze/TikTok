//
//  TabBarViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var signInPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
       
    }
    
    private func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SIgnInViewController()
            vc.completion = { [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false)
        }
    }
    
    private func setupControllers() {
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifiactions = NotificationsViewController()
        let profile = ProfileViewController(user: User(userName: "", profilePicgureURL: nil, identifier: ""))
        
        notifiactions.title = "Notifiactions"
        profile.title = "Profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let cameraNav = UINavigationController(rootViewController: camera)
        let nav3 = UINavigationController(rootViewController: notifiactions)
        let nav4 = UINavigationController(rootViewController: profile)
        
       // cameraNav.navigationBar.isHidden = true
        
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()
        
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: "Notifiactions", image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
        
        setViewControllers([nav1, nav2, cameraNav, nav3, nav4], animated: false)
    }
    
}
