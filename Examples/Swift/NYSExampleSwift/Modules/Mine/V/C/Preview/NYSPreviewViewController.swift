//
//  NYSPreviewViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/2/1.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import UIKit

class NYSPreviewViewController: NYSMineViewController {

    @IBOutlet weak var previewIV: UIImageView!
    
//    var previewUrlStr: String = "" {
//        didSet {
//            let url = URL(string: previewUrlStr)
//            self.previewIV.kf.setImage(with: url, placeholder: NAppPImg)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let url = URL(string: AppManager.shared.userInfo.icon)
//        self.previewIV.kf.setImage(with: url, placeholder: NAppPImg)
    }

}
