//
//  NYSRootViewController.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//
//  *项目中控制器继承公共基类方便统一管理，控制框架抽象的颗粒度。

import UIKit
import RxSwift
import NYSUIKit
import CoreLocation

class NYSRootViewController: NYSBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func configTheme() {
        super.configTheme()
        
        _ = self.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! Self).navBarBarTintColor = .white
            (item as! Self).navBarTintColor = .black
            (item as! Self).navBarTitleColor = .black
        })
        _ = self.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! Self).navBarBarTintColor = .black
            (item as! Self).navBarTintColor = .white
            (item as! Self).navBarTitleColor = .white
        })
    }
    
    override func setupUI() {
        super.setupUI()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }
    
}

extension NYSRootViewController {
    func checkLocationAuth(isAlways: Bool = false) {
        let status = CLLocationManager.authorizationStatus()
        
        let always = isAlways && status != .authorizedAlways
        let alertTitle = always ? "请开启持续定位权限" : "请开启定位权限"
        let alertIcon = always ? UIImage(systemName: "location.fill") : UIImage(systemName: "location")
        
        if status == .restricted || status == .denied || always {
            AlertManager.shared.showAlert(title: nil, content: alertTitle, icon: alertIcon?.withTintColor(NAppThemeColor).resized(to: CGSize(width: 36, height: 36)), confirmButtonTitle: "设置", cancelBtnTitle: nil) { popup, action, obj in
                if action == .confirm {
                    popup.dismiss(animated: true)
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
}
