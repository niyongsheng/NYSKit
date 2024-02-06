//
//  UITableView+Extension
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit
import NYSUIKit

extension UITableView {
    
    func reloadData(animationType: NYSTableViewAnimationType) {
        self.reloadData()
        if self.window != nil {
            NYSTableViewAnimation.show(with: animationType, tableView: self)
        }
    }
    
}
