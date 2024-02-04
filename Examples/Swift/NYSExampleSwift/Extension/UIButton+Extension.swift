//
//  UIButton+Extension
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit
import Kingfisher

extension UIButton {
    
    func setImage(from url: String, for state: UIControl.State = .normal, placeholder: UIImage? = nil) {
        guard let imageURL = URL(string: url) else {
            self.setImage(placeholder, for: state)
            return
        }
        
        DispatchQueue.main.async {
            self.kf.setImage(with: imageURL, for: state, placeholder: placeholder, options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ])
        }
    }
    
}

