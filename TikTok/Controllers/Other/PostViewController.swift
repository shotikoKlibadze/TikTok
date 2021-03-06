//
//  PostViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import UIKit
import AVFoundation

protocol PostViewControllerDelegate : AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
}

class PostViewController: UIViewController {
    
    var model : PostModel
    
    weak var delegate : PostViewControllerDelegate?
    
    private let likeButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        return btn
    }()
    
    private let commentButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        return btn
    }()
    
    private let shareButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        return btn
    }()
    
    private let profileButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "test"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.tintColor = .white
        btn.layer.masksToBounds = true
        return btn
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white
        label.text = "Check Out This Video , Check Out This Video ,Check Out This Video ,Check Out This Video"
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    var player: AVPlayer?
    
    private var playerdDidFinishObserver: NSObjectProtocol?
    
    //MARK: -Initializer-
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureVideo()
        setupButtons()
        setupDoubleTapToLike()
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size : CGFloat = 40
        let yStart : CGFloat = view.height - (size * 4) - 30 - view.safeAreaInsets.bottom
        for (index, button) in [likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size - 10, y: yStart + ((CGFloat(index) * 10) + CGFloat(index) * size), width: size, height: size)
        }
        
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(x: 5,
                                    y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height,
                                    width: view.width - size - 12,
                                    height: labelSize.height)
        
        profileButton.frame = CGRect(x: likeButton.left,
                                     y: likeButton.top - 10 - size,
                                     width: size,
                                     height: size)
        profileButton.layer.cornerRadius = size / 2
    }
    
    private func setupButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    private func configureVideo() {
        guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else { return }
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player?.volume = 0
        player?.play()
        
        guard let player = player else {
            return
        }

        playerdDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main,
            using: { _ in
                player.seek(to: .zero)
                player.play()
            })
    }
    
    @objc func didTapLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    
    @objc func didTapComment() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc func didTapProfileButton() {
        delegate?.postViewController(self, didTapProfileButtonFor: model)
    }
    
    @objc func didTapShare() {
        guard let url = URL(string: "https://www.tiktok.com") else { return }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(vc, animated: true)
    }
    
    func setupDoubleTapToLike() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        }
        
        let touchPoint = gesture.location(in: view)
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 0.3) {
                    imageView.alpha = 0
                } completion: { _ in
                    imageView.removeFromSuperview()
                }
            }
        }
    }
}
