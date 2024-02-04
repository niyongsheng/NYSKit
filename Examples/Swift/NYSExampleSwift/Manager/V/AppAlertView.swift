//
//  NYSAlertView.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import UIKit
import FFPopup

class AppAlertView: NYSRootAlertView {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    typealias AppAlertComplete = (_ popup: FFPopup, _ action: AppAlertAction, _ obj: Any?) -> Void
    var complete: AppAlertComplete?
    var popup: FFPopup?
    
    override func setupView() {
        super.setupView()
        
        self.addRadius(NAppRadius)
        
        iconIV.image = nil
        titleL.text = nil
        contentL.text = nil
        
        confirmBtn.backgroundColor = NAppThemeColor
        confirmBtn.setTitleColor(.white, for: .normal)
        cancelBtn.setTitleColor(NAppThemeColor, for: .normal)
        
        confirmBtn.addRadius(NAppRadius)
        cancelBtn.addCornerRadius(NAppRadius, borderWidth: 1, borderColor: NAppThemeColor)
        
        _ = self.titleL.lee_theme.leeConfigTextColor("title_label_color")
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
            complete(popup!, .close, "")
        }
    }
    
    @IBAction func cancelBtnOnclicked(_ sender: UIButton) {
        popup?.dismiss(animated: true)
        
        if let complete = complete {
            complete(popup!, .cancel, "")
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

extension AppAlertView {
    
    func configure(title: String?, content: String?, icon: UIImage?, confirmButtonTitle: String?, cancelBtnTitle: String?) {
        titleL.text = title
        contentL.text = content
        iconIV.image = icon
        confirmBtn.isHidden = confirmButtonTitle == nil
        cancelBtn.isHidden = cancelBtnTitle == nil
        confirmBtn.setTitle(confirmButtonTitle, for: .normal)
        cancelBtn.setTitle(cancelBtnTitle, for: .normal)
    }
    
}
