//
//  NYSOverdueAlertView.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/22.
//

import UIKit
import FFPopup

class NYSOverdueAlertView: NYSRootAlertView {

    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var textL: MarqueeLabel!
    
    typealias NYSOverdueAlertComplete = (_ popup: FFPopup, _ action: AppAlertAction, _ obj: Any?) -> Void
    var complete: NYSOverdueAlertComplete?
    var popup: FFPopup?
    
    override func setupView() {
        
//        _ = self.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
//            (item as! Self).backgroundColor = UIColor.init(hexString: "#FFCF8B")
//        }).leeAddCustomConfig(NIGHT, { (item: Any) in
//            (item as! Self).backgroundColor = UIColor.init(hexString: "#FF9D45")
//        })
        self.backgroundColor = UIColor.init(hexString: "#2E2F37")
        self.addRadius(NAppSpace * 0.7)
        self.actionBtn.addRadius(NAppRadius/2)
    }
    
    @IBAction func closeBtnOnclicked(_ sender: UIButton) {
        popup?.dismiss(animated: true)
        
        if let complete = complete {
            complete(popup!, .close, "")
        }
    }
    
    @IBAction func confirmBtnOnclicked(_ sender: UIButton) {
        
        if let complete = complete {
            complete(popup!, .confirm, "")
        } else {
            popup?.dismiss(animated: true)
        }
    }

}
