//
//  Transform.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

private let kPadding: CGFloat  = 10

private let kDamping: CGFloat  = 0.75

private let kVelocity: CGFloat = 2

class Transform: NSObject, UIViewControllerAnimatedTransitioning {
    
    var preIndex: Int
    
    var selectedIndex: Int
    
    override init() {
        preIndex = 0
        selectedIndex = 0
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        let translationX = containerView.bounds.size.width + kPadding
        let cgAffineTransform = CGAffineTransform(translationX: preIndex > selectedIndex ? translationX : -translationX, y: 0)
        
        toViewController.view.transform = cgAffineTransform.inverted()
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: kDamping, initialSpringVelocity: kVelocity, options: .curveEaseInOut) {
            fromViewController.view.transform = cgAffineTransform
            toViewController.view.transform = .identity
        } completion: { _ in
            fromViewController.view.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
