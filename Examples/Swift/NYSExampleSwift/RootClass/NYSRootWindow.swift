//
//  NYSRootWindow.swift
//  BaseIOS
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit
import NYSUIKit

let DAY_TAG = "day"
let NIGHT_TAG = "night"


class NYSRootWindow: UIWindow {

    override init(frame: CGRect) {
            super.init(frame: frame)
            
            if #available(iOS 13.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .light:
                    LEETheme.start(DAY)
                case .dark:
                    LEETheme.start(NIGHT)
                default:
                    break
                }
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            
            if #available(iOS 13.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .light:
                    LEETheme.start(DAY)
                case .dark:
                    LEETheme.start(NIGHT)
                default:
                    break
                }
            }
        }

}
