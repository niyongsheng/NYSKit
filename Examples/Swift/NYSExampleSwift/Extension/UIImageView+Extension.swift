//
//  UIImageView+Extension
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(from url: String, placeholder: UIImage? = nil) {
        guard let imageURL = URL(string: url) else {
            self.image = placeholder
            return
        }
        
        DispatchQueue.main.async {
            self.kf.indicatorType = .activity
            self.kf.setImage(with: imageURL, placeholder: placeholder, options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ])
        }
    }
    
}

