//
//  NYSQRCodeViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import UIKit
import SGQRCode

private let NAVBAR_TRANSLATION_POINT:CGFloat = -NTopHeight

class NYSQRCodeViewController: NYSRootViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
    @IBOutlet weak var qrCodeIV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "二维码"
        
        self.checkLocationAuth(isAlways: true)
        DispatchQueue.global(qos: .default).async {
            let qrImg = SGGenerateQRCode.generateQRCode(withData: "https://github.com/niyongsheng", size: 200, color: NAppThemeColor, backgroundColor: .clear)
            
            DispatchQueue.main.async {
                self.qrCodeIV.image = qrImg
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavigationBarTransformProgress(progress: 0)
    }
    
    override func setupUI() {
        super.setupUI()
        
        navBarBackgroundAlpha = 1
        self.scrollView.delegate = self

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("offsetY: \(offsetY)")
        if (offsetY > NAVBAR_TRANSLATION_POINT) {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let weakSelf = self {
                    weakSelf.setNavigationBarTransformProgress(progress: 1)
                }
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let weakSelf = self {
                    weakSelf.setNavigationBarTransformProgress(progress: 0)
                }
            })
        }
    }
    
    private func setNavigationBarTransformProgress(progress:CGFloat) {
        navigationController?.navigationBar.wr_setTranslationY(translationY: -CGFloat(NTopHeight) * progress)
        navigationController?.navigationBar.wr_setBarButtonItemsAlpha(alpha: 1 - progress, hasSystemBackIndicator: true)
    }
}
