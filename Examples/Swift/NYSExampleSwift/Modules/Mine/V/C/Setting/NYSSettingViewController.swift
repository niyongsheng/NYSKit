//
//  NYSSettingViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/29.
//

import UIKit
import AcknowList

class NYSSettingViewController: NYSRootViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.navigationItem.title = "设置"
        
        self.logoutBtn.setTitleColor(NAppThemeColor, for: .normal)
        self.logoutBtn.addCornerRadius(NAppRadius, borderWidth: 1, borderColor: NAppThemeColor)
    }

    @IBAction func logoutBtnOnclicked(_ sender: UIButton) {
        NYSTools.zoom(toShow: sender.layer)
        
        let alertVC = UIAlertController.init(title: "退出登录", message: "确定要退出登录吗？", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "确定", style: .destructive) { (action) in
            AppManager.shared.logoutHandler()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func itemOnclicked(_ sender: UIButton) {
        if sender.tag == 100 {
            self.navigationController?.pushViewController(NYSLogoffViewController.init(), animated: true)
             
        } else if sender.tag == 101 {
            let webVC = NYSRootWebViewController.init()
            webVC.urlStr = "https://example.com/"
            self.navigationController?.pushViewController(webVC, animated: true)
            
        } else if sender.tag == 102 {
            let webVC = NYSRootWebViewController.init()
            webVC.urlStr = "https://example.com/"
            self.navigationController?.pushViewController(webVC, animated: true)
            
        } else if sender.tag == 103 {
            self.navigationController?.pushViewController(NYSThirdPartyViewController.init(), animated: true)
            
//            let navVC = NYSBaseNavigationController.init(rootViewController: AcknowListViewController.init(fileNamed: "Pods-NYSAppSwift-acknowledgements"))
//            self.present(navVC, animated: true)
        }
    }
}
