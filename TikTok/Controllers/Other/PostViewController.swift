//
//  PostViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import UIKit

class PostViewController: UIViewController {
    
    let model : PostModel
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors : [UIColor] = [.red, .green, .yellow, .white, .orange, .blue, .systemRed, .systemPink]
        view.backgroundColor = colors.randomElement()

       
    }
    


}
