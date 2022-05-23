//
//  ExploreViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import UIKit

class ExploreViewController: UIViewController {

    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()

    private var collectionView : UICollectionView?
    private var sections = [ExploreSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ExploreManager.shared.delegate = self
        view.backgroundColor = .systemBackground
        configureModels()
        setupSearchBar()
        setupCollectionView()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }

    private func setupSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    private func configureModels() {
        
        sections.append(ExploreSection(
            type: .banners, cells: ExploreManager.shared.getExploreBanners().compactMap({ return ExploreCell.banner(viewModel: $0)})))
        
        sections.append(ExploreSection(type: .trendingPosts, cells: ExploreManager.shared.getEploreTrendingPosts().compactMap({return ExploreCell.post(viewModel: $0)})))

        sections.append(ExploreSection(type: .users, cells: ExploreManager.shared.getExploreCreators().compactMap({ return ExploreCell.user(viewModel: $0)})))

        sections.append(ExploreSection(type: .trendingHashtags, cells: ExploreManager.shared.getExploreHashtags().compactMap({return ExploreCell.hashtag(viewModel: $0)})))

        sections.append(ExploreSection(type: .popular, cells: ExploreManager.shared.getEplorePopularPosts().compactMap({return ExploreCell.post(viewModel: $0)})))

        sections.append(ExploreSection(type: .new, cells: ExploreManager.shared.getEploreRecentPosts().compactMap({return ExploreCell.post(viewModel: $0)})))

    }

    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { section, _  -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        })

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground

        collectionView.register(ExploreBannerCollectionViewCell.self, forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        collectionView.register(ExploreUserCollectionViewCell.self, forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        collectionView.register(ExplorePostCollectionViewCell.self, forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(ExploreHashtagCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier)

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        view.addSubview(collectionView)
        self.collectionView = collectionView

    }
}

extension ExploreViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]

        switch model {
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreBannerCollectionViewCell.identifier, for: indexPath) as? ExploreBannerCollectionViewCell else { return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) }
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorePostCollectionViewCell.identifier, for: indexPath) as? ExplorePostCollectionViewCell else { return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier, for: indexPath) as? ExploreHashtagCollectionViewCell else { return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) }
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreUserCollectionViewCell.identifier, for: indexPath) as? ExploreUserCollectionViewCell  else { return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) }
            cell.configure(with: viewModel)
            return cell
        }

//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .red
//        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let model = sections[indexPath.section].cells[indexPath.row]

        switch model {
        case .banner(let viewModel):
            viewModel.handler()
        case .post(let viewModel):
            viewModel.handler()
        case .hashtag(let viewModel):
            viewModel.handler()
        case .user(let viewModel):
            viewModel.handler()
        }
    }

}

extension ExploreViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
    }
    
    @objc func didTapCancel() {
        navigationItem.rightBarButtonItem = nil
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = nil
        searchBar.resignFirstResponder()
    }

}

extension ExploreViewController : ExploreManagerDelegate {
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Section Layouts -

extension ExploreViewController {

    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        switch sectionType {
        case .banners:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case .users:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(200)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .trendingHashtags:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
            let section = NSCollectionLayoutSection(group: verticalGroup)

            return section
        case .trendingPosts, .new:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(100), heightDimension: .absolute(300)), subitem: item, count: 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(110), heightDimension: .absolute(300)), subitems: [verticalGroup])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .popular:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(110), heightDimension: .absolute(200)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}


