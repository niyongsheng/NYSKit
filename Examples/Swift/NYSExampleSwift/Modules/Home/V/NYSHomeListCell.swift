//
//  NYSHomeListCell.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import UIKit
import FlexLib

@objc(NYSHomeListCell)
class NYSHomeListCell: FlexBaseTableCell {

    @objc private var headIV : UIImageView!
    @objc private var nameL : UILabel!
    @objc private var typeL : UILabel!
    @objc private var dateL : UILabel!
    @objc private var titleL : UILabel!
    @objc private var contentL : UILabel!
    
    var model: NYSHomeList! {
        didSet {
            nameL.text = model.name
            typeL.text = model.type
            dateL.text = model.date
            titleL.text = model.title
            contentL.text = model.content
        }
    }
    
    override func onInit() {
//        headIV.isUserInteractionEnabled = true
        headIV.addTapAction { sender in
            NYSTools.zoom(toShow: sender?.layer)
        }
    }
    
}
