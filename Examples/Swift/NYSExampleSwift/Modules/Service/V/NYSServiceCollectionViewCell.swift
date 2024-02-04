//
//  NYSServiceCollectionViewCell.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/15.
//

import UIKit

class NYSServiceCollectionViewCell: UICollectionViewCell {
    static let ID = "NYSServiceCollectionViewCell"

    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var starL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var descL: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoBtn.addRadius(NAppRadius)
//        bgV.layer.addSublayer(UIColor.gradient(from: .randomColor, to: .randomColor, direction: .horizontal))
    }
    
    var model: NYSService! {
        didSet {
            titleL.text = model.name
            starL.text = "\(model.star)k"
            descL.text = model.desc
            bgV.backgroundColor = UIColor.init(hexString: model.bgColor)
        }
    }

}
