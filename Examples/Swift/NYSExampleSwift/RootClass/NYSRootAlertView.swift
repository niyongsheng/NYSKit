//
//  NYSRootAlertView.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSRootAlertView: UIView {
    enum AppAlertAction {
        case confirm
        case cancel
        case close
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXIB()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureXIB()
        setupView()
    }
    
    private func configureXIB() {
        guard let view = loadViewFromNib() else { return }
        view.backgroundColor = .clear
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        
        return bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
    }
    
    func setupView() {
        _ = self.lee_theme.leeConfigBackgroundColor("alert_view_bg_color")
    }
}
