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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func didTapPost() {
        ProgressHUD.show("Posting")
        //Generate video name
        let videoName = StorageManager.shared.generateVideoName()
        //Upload video
        StorageManager.shared.uploadVideoURL(url: videoURL, fileName: videoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    //Update Database
                    DatabaseManager.shared.insertPost(fileName: videoName) { databaseUpdated in
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
