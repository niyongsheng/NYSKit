//
//  NYSPullerViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/31.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import UIKit
import NYSUIKit

class NYSPullerViewController: PullUpController {
    
    @IBOutlet weak var visualEV: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 主题适配
        _ = self.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! Self).visualEV.effect = UIBlurEffect(style: .light)
            
        }).leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! Self).visualEV.effect = UIBlurEffect(style: .dark)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.cornerRadius = NAppRadius
        view.layer.masksToBounds = true
    }

    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: NScreenWidth, height: NScreenHeight - NTopHeight)
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return [70 + NBottomHeight, NScreenHeight - pro_headerViewHeight]
    }

    override var pullUpControllerBounceOffset: CGFloat {
        return 20
    }
    
}
