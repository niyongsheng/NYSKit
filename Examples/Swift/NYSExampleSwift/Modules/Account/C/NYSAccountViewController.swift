//
//  NYSScrollViewController.swift
//  BaseIOS
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSAccountViewController: NYSRootViewController, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
    @IBOutlet weak var protocolT: UITextView!
    @IBOutlet weak var oneKeyBtn: UIButton!
    @IBOutlet weak var otherAccountBtn: UIButton!
    
    private let tipV: CMPopTipView = {
        let tipV = CMPopTipView()
        tipV.backgroundColor = NAppThemeColor
        tipV.preferredPointDirection = .up
        tipV.borderColor = .clear
        tipV.titleColor = .white
        tipV.hasGradientBackground = false
        tipV.hasShadow = false
        tipV.has3DStyle = false
        return tipV
    }()
    
    var isChecked = false
    lazy var checkBox: BFPaperCheckbox = {
        let checkbox = BFPaperCheckbox(frame: CGRect(x: self.protocolT.left - 40, y: self.protocolT.top - 10, width: 50, height: 50))
        checkbox.rippleFromTapLocation = true
        checkbox.addTarget(self, action: #selector(checkBoxOnclicked(_:)), for: .touchUpInside)
        return checkbox
    }()

    @objc func checkBoxOnclicked(_ sender: BFPaperCheckbox) {
        isChecked = !isChecked
        if isChecked {
            sender.check(animated: true)
        } else {
            sender.uncheck(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        navBarBackgroundAlpha = 0
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.oneKeyBtn.addRadius(NAppRadius)
        self.oneKeyBtn.backgroundColor = NAppThemeColor
        self.otherAccountBtn.setTitleColor(NAppThemeColor, for: .normal)
        self.otherAccountBtn.addCornerRadius(NAppRadius, borderWidth: 1, borderColor: NAppThemeColor)
        
        let protocolStr: String = "阅读并同意《服务协议》《隐私政策》"
        let attString = NSMutableAttributedString(string: protocolStr)
        attString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: protocolStr.count))
        attString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: protocolStr.count))
        let range1 = (protocolStr as NSString).range(of: "《服务协议》")
        let range2 = (protocolStr as NSString).range(of: "《隐私政策》")
        attString.addAttribute(NSAttributedString.Key.link, value: "service://", range: range1)
        attString.addAttribute(NSAttributedString.Key.link, value: "privacy://", range: range2)
        protocolT.linkTextAttributes = [NSAttributedString.Key.foregroundColor: NAppThemeColor]
        protocolT.delegate = self
        protocolT.attributedText = attString
        
        self.contenView.addSubview(self.checkBox)
    }
    
    override func configTheme() {
        super.configTheme()
        
    }
    
    @IBAction func oneKeyBtnOnclicked(_ sender: UIButton) {
        AlertManager.shared.showAlert(title: "未检测到SIM卡")
    }
    
    @IBAction func otherAccountBtnOnclicked(_ sender: UIButton) {
        if !self.isChecked {
            NYSTools.shakeAnimation(self.checkBox.layer)
            tipV.message = "请勾选"
            tipV.autoDismiss(animated: true, atTimeInterval: 2)
            tipV.presentPointing(at: self.checkBox, in: contenView, animated: true)
            return
        }
        self.navigationController?.pushViewController(NYSLoginViewController(), animated: true)
    }
    
    @IBAction func agreeBtnOnclicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func wechatBtnOnclicked(_ sender: UIButton) {
        
    }
    
    @IBAction func appleBtnOnclicked(_ sender: UIButton) {
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "service" {
            let webVC = NYSRootWebViewController.init()
            webVC.title = "服务协议"
            webVC.urlStr = "https://example.com/"
            self.navigationController?.pushViewController(webVC, animated: true)
            
        } else if URL.scheme == "privacy" {
            let webVC = NYSRootWebViewController.init()
            webVC.title = "隐私政策"
            webVC.urlStr = "https://example.com/"
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
        return true
    }
}
