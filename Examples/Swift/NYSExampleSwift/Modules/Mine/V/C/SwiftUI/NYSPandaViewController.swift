//
//  NYSPandaViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/29.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import UIKit
import SwiftUI

class NYSPandaViewController: NYSRootViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.navigationItem.title = "SwiftUI & UIKit"
        
        if #available(iOS 15.0, *) {
            // 创建一个 SwiftUI 视图
            let memeCreator = MemeCreator().padding()
            
            // 使用 UIHostingController 将 SwiftUI 视图包装到 UIKit 中
            let hostingController = UIHostingController(rootView: memeCreator)
            
            // 添加 UIHostingController 到当前视图控制器的子视图
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)
            
            // 手动布局约束
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            switch traitCollection.userInterfaceStyle {
            case .light:
                self.navBarBarTintColor = .white
                self.navBarTintColor = .black
                self.navBarTitleColor = .black
                break
            case .dark:
                self.navBarBarTintColor = .black
                self.navBarTintColor = .white
                self.navBarTitleColor = .white
                break
            default:
                break
            }
        }
    }
    
}

/// 桥接预览
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        NYSPandaViewController().showPreview()
    }
}
