//
//  ExploreUserCollectionViewCell.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 16.05.22.
//

import UIKit

class ExploreUserCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ExploreUserCollectionViewCell"
    
    let imageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.layer.masksToBounds = true
        imgv.clipsToBounds = true
        imgv.backgroundColor = .secondarySystemBackground
        return imgv
    }()
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 18, weight: .light)
        lbl.textAlignment = .center
        return lbl
    }()
    
   override init(frame: CGRect) {
       super.init(frame: frame)
       contentView.clipsToBounds = true
       contentView.addSubview(imageView)
       contentView.addSubview(label)
       contentView.layer.cornerRadius = 8
       contentView.layer.masksToBounds = true
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   override func layoutSubviews() {
       super.layoutSubviews()
       let imageSize: CGFloat = contentView.height - 55
       imageView.frame = CGRect(x: (contentView.width - imageSize) / 2, y: 0, width: imageSize, height: imageSize)
       imageView.layer.cornerRadius = imageView.height / 2
       label.frame = CGRect(x: 0, y: imageView.bottom, width: contentView.width, height: 55)
   }
   
   override func prepareForReuse() {
       super.prepareForReuse()
       imageView.image = nil
       label.text = nil
   }
   
   func configure(with viewModel: ExploreUserViewModel) {
       label.text = viewModel.userName
       imageView.image = viewModel.profilePic
   }
}
