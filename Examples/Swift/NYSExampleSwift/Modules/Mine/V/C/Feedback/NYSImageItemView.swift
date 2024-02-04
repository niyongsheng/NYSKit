//
//  NYSImageItemView.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/24.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import Foundation
import FlexLib

@objc(NYSImageItemView)
class NYSImageItemView: FlexCustomBaseView {
    
    typealias DelBlock = () -> Void
    var delBlock: DelBlock?
    
    @objc var selectedIV: UIImageView!
    @objc var delIV: UIImageView!
    
    override func onInit() {
        self.flexibleWidth = false
        self.flexibleHeight = false
    }
    
    @objc func delTouchVOnpress() -> Void {
        if let delBlock = self.delBlock {
            delBlock()
        }
    }
}
