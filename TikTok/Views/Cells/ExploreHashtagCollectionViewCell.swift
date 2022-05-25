//
//  ExploreHashtagCollectionViewCell.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 16.05.22.
//

import UIKit

class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreHashtagCollectionViewCell"
    
    let imageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    
   override init(frame: CGRect) {
       super.init(frame: frame)
       contentView.clipsToBounds = true
       contentView.addSubview(imageView)
       contentView.addSubview(label)
       contentView.backgroundColor = .systemGray5
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   override func layoutSubviews() {
       super.layoutSubviews()
       let imageSize: CGFloat = contentView.height / 3
       imageView.frame = CGRect(x: 10, y: (contentView.height - imageSize) / 2, width: imageSize, height: imageSize).integral
       imageView.layer.cornerRadius = imageView.height / 2
       label.sizeToFit()
       label.frame = CGRect(x: imageView.right +  10, y: 0, width: contentView.width - imageView.right - 10, height: contentView.height).integral
   }
   
   override func prepareForReuse() {
       super.prepareForReuse()
       imageView.image = nil
       label.text = nil
   }
   
   func configure(with viewModel: ExploreHashtagViewModel) {
       label.text = viewModel.text
       imageView.image = viewModel.icon
   }
}
