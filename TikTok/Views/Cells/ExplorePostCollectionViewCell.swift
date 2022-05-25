//
//  ExplorePostCollectionViewCell.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 16.05.22.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExplorePostCollectionViewCell"
    
    let imageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        return imgv
    }()
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
       // lbl.font = .systemFont(ofSize: 20, weight: .semibold)
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
       let captionHeight = contentView.height / 5
       imageView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - captionHeight)
       label.frame = CGRect(x: 0, y: contentView.height - captionHeight, width: contentView.width, height: captionHeight)
   }
   
   override func prepareForReuse() {
       super.prepareForReuse()
       imageView.image = nil
       label.text = nil
   }
   
   func configure(with viewModel: ExplorePostViewModel) {
       label.text = viewModel.caption
       imageView.image = viewModel.thumbnailImage
   }
}
