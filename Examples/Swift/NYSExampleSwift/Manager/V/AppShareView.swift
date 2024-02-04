//
//  NYSAlertView.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import UIKit
import FFPopup

class AppShareView: NYSRootAlertView {
    
    enum AppShareType {
        case none
        case qq
        case wechat
        case weibo
        case facebook
        case system
    }
    
    typealias AppShareComplete = (_ popup: FFPopup, _ action: AppAlertAction, _ type:AppShareType, _ obj: Any?) -> Void
    var complete: AppShareComplete?
    var popup: FFPopup?
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var contentV: UIView!
    @IBOutlet weak var bottomH: NSLayoutConstraint!
    
    override func setupView() {
        super.setupView()
        
        self.addRoundedCorners(corners: [.topLeft, .topRight], radius: NAppRadius, borderWidth: 0, borderColor: .clear)
        
        iconIV.image = nil
        confirmBtn.backgroundColor = NAppThemeColor
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.addRadius(NAppRadius*2)
        bottomH.constant = UIDevice.nys_isIphoneX() ? NSafeBottomHeight : 20
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.layoutFittingCompressedSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    @IBAction func closeBtnOnclicked(_ sender: UIButton) {
        popup?.dismiss(animated: true)
        
        if let complete = complete {
            complete(popup!, .close, .none, "")
        }
    }
    
    @IBAction func confirmBtnOnclicked(_ sender: UIButton) {
        
        if let complete = complete {
            complete(popup!, .confirm, .none, "")
        } else {
            popup?.dismiss(animated: true)
        }
    }
}

extension AppShareView {
    
    func configure(content: Any?, icon: UIImage?, confirmButtonTitle: String?) {
        iconIV.image = icon
        confirmBtn.setTitle(confirmButtonTitle, for: .normal)
        // TODO: - content
        
        
    }
    
}
