//
//  NYSBannerCollectionViewCell.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/29.
//

import UIKit

class NYSBannerCollectionViewCell: UICollectionViewCell {
    
    private lazy var bannerIV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var urlStr: String = "" {
        didSet {
            self.bannerIV.setImage(from: urlStr, placeholder: NAppPImg)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bannerIV.frame = contentView.bounds
        contentView.addSubview(bannerIV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
