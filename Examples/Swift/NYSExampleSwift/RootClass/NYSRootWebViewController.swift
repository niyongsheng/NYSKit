//
//  NYSRootWebViewController.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSRootWebViewController: NYSWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configTheme() {
        super.configTheme()
        
        _ = self.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! NYSRootWebViewController).navBarBarTintColor = .white
            (item as! NYSRootWebViewController).navBarTintColor = .black
            (item as! NYSRootWebViewController).navBarTitleColor = .black
        })
        _ = self.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! NYSRootWebViewController).navBarBarTintColor = .black
            (item as! NYSRootWebViewController).navBarTintColor = .white
            (item as! NYSRootWebViewController).navBarTitleColor = .white
        })
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.autoTitle = true
        self.progressView.tintColor = NAppThemeColor
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }

}
