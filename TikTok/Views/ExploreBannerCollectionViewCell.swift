//
//  ExploreBannerCollectionViewCell.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 16.05.22.
//

import UIKit

class ExploreBannerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ExploreBannerCollectionViewCell"
    
    let imageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        return imgv
    }()
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 24, weight: .semibold)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        imageView.frame = contentView.bounds
        contentView.bringSubviewToFront(label)
        label.frame = CGRect(x: 10, y: contentView.height - 5 - label.height, width: label.width, height: label.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    func configure(with viewModel: ExploreBannerViewModel) {
        imageView.image = viewModel.image
        label.text = viewModel.title
    }
    
}
