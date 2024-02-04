//
//  NYSLogoffViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/24.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import UIKit
import SnapKit

class NYSLogoffViewController: NYSRootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.navigationItem.title = "注销"
        
        let logoutIcon = UIImageView(image: UIImage(named: "ic_88px_warm"))
        view.addSubview(logoutIcon)
        
        let titleLabel = UILabel()
        titleLabel.text = "为了保证您的信息安全，请在注销账号前确定以下条件是否符合："
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        let specialLabel = UILabel()
        specialLabel.text = "·账号金额已清算完成；\n·账号中没有未完成运单；"
        specialLabel.textColor = UIColor.red
        specialLabel.textAlignment = .center
        specialLabel.numberOfLines = 0
        view.addSubview(specialLabel)
        
        // 注销按钮
        let logoffBtn = UIButton(type: .system)
        logoffBtn.setTitle("注销账号", for: .normal)
        logoffBtn.addTarget(self, action: #selector(logoffBtnTapped), for: .touchUpInside)
        logoffBtn.setTitleColor(NAppThemeColor, for: .normal)
        logoffBtn.addCornerRadius(NAppRadius, borderWidth: 1, borderColor: NAppThemeColor)
        view.addSubview(logoffBtn)
        
        // 设置约束
        logoutIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(NAppSpace)
            make.top.equalTo(logoutIcon.snp.bottom).offset(10)
        }
        
        specialLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(NAppSpace)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        logoffBtn.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(NAppSpace)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
    }
    
    @objc func logoffBtnTapped() {
        AlertManager.shared.showAlert(title: "请再次确认是否注销账号", content: "注销成功后，资料将被清除，无法找回", icon: nil, confirmButtonTitle: "确定", cancelBtnTitle: "再想想") { popup, action, obj in
            if action == .confirm {
                popup.dismiss(animated: true)
                
            }
        }
    }
}
