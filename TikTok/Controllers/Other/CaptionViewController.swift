//
//  CaptionViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 27.05.22.
//

import UIKit
import ProgressHUD

class CaptionViewController: UIViewController {
    
    let videoURL : URL
    
    private let captionTextView : UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        view.addSubview(captionTextView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top + 5 , width: view.width - 10, height: 150).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    @objc func didTapPost() {
        
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        
        ProgressHUD.show("Posting")
        //Generate video name
        let videoName = StorageManager.shared.generateVideoName()
        //Upload video
        StorageManager.shared.uploadVideoURL(url: videoURL, fileName: videoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    //Update Database
                    DatabaseManager.shared.insertPost(fileName: videoName, caption: caption) { databaseUpdated in
                        if databaseUpdated {
                            HapticsManager.shared.vibrate(for: .success)
                            ProgressHUD.dismiss()
                            //Reset camera and switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                            ProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Opps", message: "Unable to upload video", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                            self?.present(alert, animated: true)
                        }
                    }
                } else {
                    ProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Opps", message: "Unable to upload video", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
