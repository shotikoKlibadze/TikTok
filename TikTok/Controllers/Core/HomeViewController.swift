//
//  ViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let horizontalScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let controll : UISegmentedControl = {
        let titles = ["Following", "For You"]
        let controll = UISegmentedControl(items: titles)
        controll.selectedSegmentIndex = 1
        controll.backgroundColor = nil
        controll.selectedSegmentTintColor = .white
        return controll
    }()
    
    let forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: nil)
    
    let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: nil)
    
    private let forYouPosts = PostModel.mockModels()
    private let followingPosts = PostModel.mockModels()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        horizontalScrollView.delegate = self
        setupFeed()
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setupHeaderButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    private func setupHeaderButtons() {
        controll.addTarget(self, action: #selector(didChangeSegmentedControl(sender:)), for: .valueChanged)
        navigationItem.titleView = controll
    }
    
    @objc func didChangeSegmentedControl(sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex), y: 0), animated: true)
    }
    
   
    
    private func setupFeed() {
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        setupForYouFeed()
        setupFollowingFeed()
       
    }
    
    private func setupFollowingFeed() {
        guard let model = followingPosts.first else { return }
        followingPageViewController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward,
            animated: false,
            completion: nil)
        followingPageViewController.dataSource = self
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    private func setupForYouFeed() {
        //For you
        guard let model = forYouPosts.first else { return }
        forYouPageViewController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward,
            animated: false,
            completion: nil)
        forYouPageViewController.dataSource = self
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame =  CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
    }
}

extension HomeViewController : UIPageViewControllerDataSource {
    //Function that returns previous post
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }

        guard let index = currentPosts.firstIndex(where: { model in
            model.identifier == fromPost.identifier
        
        }) else {
            return nil
            
        }
        if index == 0 { return nil}
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    //Function that returns next post
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: { model in
            model.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        guard index < (currentPosts.count - 1) else { return nil }
        let nextIndex  = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    var currentPosts : [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            return followingPosts
        }
        return forYouPosts
    }
}

extension HomeViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width / 2){
            controll.selectedSegmentIndex = 0
        } else if scrollView.contentOffset.x > (view.width / 2){
            controll.selectedSegmentIndex = 1
        }
    }
}

