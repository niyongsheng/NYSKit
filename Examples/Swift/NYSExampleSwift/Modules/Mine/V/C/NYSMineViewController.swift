//
//  NYSMineViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import UIKit
import NYSUIKit
import RxSwift

class NYSMineViewController: NYSRootViewController, UIScrollViewDelegate {
    
    private let bag = DisposeBag()
    private let userinfoSubject = AppManager.shared.userinfoSubject

    let NAVBAR_COLORCHANGE_POINT:CGFloat = 100
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    
    @IBOutlet weak var qrIV: UIImageView!
    @IBOutlet weak var portraitBtn: UIButton!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var subtitleL: UILabel!
    
    @IBOutlet weak var lineV: UIView!
    @IBOutlet weak var bannerBgV: UIView!
    
    @IBOutlet weak var oneSV: UIStackView!
    @IBOutlet weak var twoSV: UIStackView!
    @IBOutlet weak var threeSV: UIStackView!
    @IBOutlet weak var fourSV: UIStackView!
    
    @IBOutlet weak var serviceL: UILabel!
    @IBOutlet weak var serviceTelBtn: UIButton!
    
    @IBOutlet weak var infoL: UILabel!
    
    lazy var amapLocation: NYSAMapLocation? = {
        let location = NYSAMapLocation()
        return location
    }()
    
    lazy var systemLocation: NYSSystemLocation? = {
        let location = NYSSystemLocation()
        return location
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的"
        self.scrollView.delegate = self
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNav(self.scrollView)
        AppManager.shared.refreshUserInfo(completion: { isSuccess, userInfo, error in
            if isSuccess {
                self.titleL.text = userInfo?.nickname
                if let firstRole = userInfo?.roleArr.first {
                    self.subtitleL.text = firstRole + " >"
                }
                self.serviceTelBtn.setTitle(userInfo?.tel, for: .normal)
            
            } else {
                self.titleL.text = "未登录"
                self.subtitleL.text = "去认证 >"
                self.serviceTelBtn.setTitle("400-000-0000", for: .normal)
            }
            
            self.portraitBtn.setImage(from: userInfo?.icon ?? "", placeholder: UIImage.init(named: "pic_32px_def_touxiang"))
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navBarBackgroundAlpha = 1
        navBarBarTintColor = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "default_nav_bar_bar_tint_color") as! UIColor
        navBarTintColor = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "default_nav_bar_tint_color") as! UIColor
        navBarTitleColor = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "default_nav_bar_title_color") as! UIColor
    }
    
    override func setupUI() {
        super.setupUI()
        
        bannerBgV.addRadius(NAppRadius)
        oneSV.addRadius(NAppRadius)
        twoSV.addRadius(NAppRadius)
        threeSV.addRadius(NAppRadius)
        fourSV.addRadius(NAppRadius)
        portraitBtn.addRadius(30)
        qrIV.addRadius(5)
        
        navBarBackgroundAlpha = 0
        navBarTintColor = .clear
        navBarTitleColor = .clear
        
        if let customFont = UIFont(name: "DOUYU Font", size: 14) {
            serviceL.font = customFont
            serviceTelBtn.titleLabel?.font = customFont
        }
        
        portraitBtn.addTapAction { sender in
            let webVC = NYSRootWebViewController.init()
            webVC.urlStr = "https://niyongsheng.github.io/pixel_homepage/"
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
        qrIV.addTapAction { sender in
            NYSTools.zoom(toShow: sender?.layer)
            
            let attributedText = NSMutableAttributedString(string: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
            let linkRange = NSRange(location: 354, length: 46)
            let linkURL = URL(string: "https://example.com")
            attributedText.addAttributes([NSAttributedString.Key.link: linkURL!], range: linkRange)
            attributedText.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: linkRange)
            attributedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                          NSAttributedString.Key.foregroundColor: UIColor.darkGray],
                                         range: NSRange(location: 0, length: attributedText.length))
            AlertManager.shared.showTextAlert(attributedText: attributedText)
        }
    }

    override func configTheme() {
        super.configTheme()
        
        _ = self.lineV.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.init(hexString: "#F0F0F0")
        })
        _ = self.lineV.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.white
        })
        
        _ = self.contenView.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.init(hexString: "#F0F0F0")
        })
        _ = self.contenView.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.init(hexString: "#101010")
        })
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNav(scrollView)
    }
    
    private func updateNav(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NTopHeight
        if offsetY > NAVBAR_COLORCHANGE_POINT {
            self.navBarBackgroundAlpha = alpha
            if LEETheme.currentThemeTag().contains(DAY) {
                self.navBarTintColor = UIColor.black.withAlphaComponent(alpha)
                self.navBarTitleColor = UIColor.black.withAlphaComponent(alpha)
            } else if LEETheme.currentThemeTag().contains(NIGHT) {
                self.navBarTintColor = UIColor.white.withAlphaComponent(alpha)
                self.navBarTitleColor = UIColor.white.withAlphaComponent(alpha)
            }
            
        } else {
            self.navBarBackgroundAlpha = 0
            self.navBarTintColor = .clear
            self.navBarTitleColor = .clear
        }
    }
    
    @IBAction func itemOnclicked(_ sender: UIButton) {
        if AppManager.shared.isLogin == false {
            AlertManager.shared.showLogin()
            return
        }
        
        if sender.tag == 100 {
            let webVC = NYSRootWebViewController.init()
            webVC.urlStr = "https://github.com/niyongsheng/NYSWS/tree/main/NYSWS/"
            self.navigationController?.pushViewController(webVC, animated: true)
             
        } else if sender.tag == 101 {
            self.navigationController?.pushViewController(NYSQRCodeViewController.init(), animated: true)
            
        } else if sender.tag == 102 {
            self.navigationController?.pushViewController(NYSSettingViewController.init(), animated: true)
            
        } else if sender.tag == 103 {
            AlertManager.shared.showShare(content: nil)
            
        } else if sender.tag == 104 {
            self.navigationController?.pushViewController(NYSFeedbackViewController.init(), animated: true)
            
        } else if sender.tag == 200 {
            AlertManager.shared.showOverdueAlert(text: "提醒一：未完成基础信息认证,未完成基础信息认证,未完成基础信息认证,未完成基础信息认证,", index: 1, inView: nil)
            
        } else if sender.tag == 201 {
            AlertManager.shared.showOverdueAlert(text: "提醒二：未完成驾驶信息认证", index: 2, inView: nil)
            
        } else if sender.tag == 202 {
            AlertManager.shared.showOverdueAlert(text: "提醒三：未完成车辆信息认证", index: 3, inView: nil)
            
        } else if sender.tag == 300 {
            AlertManager.shared.showAlert(title: "强提醒信息弹窗")
            
        } else if sender.tag == 301 {
            AlertManager.shared.showAlert(title: "标题", content: "标题+内容弹窗", icon: nil, confirmButtonTitle: nil, cancelBtnTitle: "好的")
            
        } else if sender.tag == 302 {
            AlertManager.shared.showAlert(title: "标题", content: "图标+标题+内容弹窗", icon: UIImage(named: "okay_icon")?.resized(to: CGSizeMake(60, 60)), confirmButtonTitle: "确定", cancelBtnTitle: nil)
            
        } else if sender.tag == 303 {
            AlertManager.shared.showAlert(title: "自定义图标+按钮弹窗", content: nil, icon: UIImage(named: "ic_88px_warm")?.resized(to: CGSizeMake(60, 60)), confirmButtonTitle: "朕知道了", cancelBtnTitle: "退下吧")
            
        } else if sender.tag == 400 {
            if #available(iOS 15.0, *) {
                self.navigationController?.pushViewController(NYSPandaViewController.init(), animated: true)
            }
            
        } else if sender.tag == 401 {
            systemLocation?.completion = { [weak self] address, coordinate, error in
                DispatchQueue.main.async {
                    if let nsError = error as NSError? {
                        NYSTools.showBottomToast("Location Error:\(nsError.code) \n \(nsError.localizedDescription)")
                        self?.checkLocationAuth(isAlways: true)
                    } else {
                        NYSTools.showToast("定位成功", image: UIImage(systemName: "location"), offset:UIOffset(horizontal: 0, vertical: 0))
                        self?.infoL.text = "经度：\(coordinate.longitude)\n纬度：\(coordinate.latitude)\n地址：\(address)"
                    }
                }
            }
            systemLocation?.requestSystem()
            
//            systemLocation?.completion = { address, latitude, longitude, error in
//
//            }
//            amapLocation?.requestReGeocode()
            
        } else if sender.tag == 402 {
            let latitude: CLLocationDegrees = 39.9
            let longitude: CLLocationDegrees = 116.38
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            NYSTools.navigate(toAddress: "北京", coordinate: coordinate, viewController: self)
            
        } else {
            NYSTools.log("未定义")
        }
    }
    
    @IBAction func serviceTelBtnOnclicked(_ sender: UIButton) {
        guard let telURL = URL(string: "tel://" + (AppManager.shared.userInfo.tel ?? ""))  else {
            return
        }
        
        if UIApplication.shared.canOpenURL(telURL) {
            UIApplication.shared.open(telURL, options: [:], completionHandler: nil)
        } else {
            print("无法呼叫电话")
        }
    }
    
}
