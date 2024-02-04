//
//  NYSContentViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/12.
//

import UIKit

class NYSContentViewController: NYSRootViewController {
    
    var didSetupConstraints = false
    
    let scrollView  = UIScrollView()
    let contentView = UIView()
    
    let contentL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        return label
    }()
    
    let titleL: MarqueeLabel = {
        let label = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: NScreenWidth - 150, height: 44), duration: 8.0, fadeLength: 10.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = titleL
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentL)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsets.zero)
            }
            
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(scrollView).inset(UIEdgeInsets.zero)
                make.width.equalTo(scrollView)
            }
            
            contentL.snp.makeConstraints { make in
                make.top.equalTo(contentView).inset(NAppSpace)
                make.leading.equalTo(contentView).inset(NAppSpace)
                make.trailing.equalTo(contentView).inset(NAppSpace)
                make.bottom.equalTo(contentView).inset(NAppSpace)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}
