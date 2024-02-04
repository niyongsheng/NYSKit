//
//  NYSTabBarViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/19.
//

import UIKit
import NYSUIKit
import Lottie

class NYSTabBarViewController: NYSBaseTabBarController, UITabBarControllerDelegate {
    var curSelectedIndex:Int = 0
    
    lazy var transform = Transform()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isOpenGradualAnimation = false
        
        self.delegate = self
        self.viewControllers = self.createTabBarViewControllers()
        UITabBar.appearance().unselectedItemTintColor = .darkGray
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = NAppThemeColor
        
        _ =  self.tabBar.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UITabBar).backgroundColor = .white
        })
        _ =  self.tabBar.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UITabBar).backgroundColor = .black
        })
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        stopTabBarAnimation()
//        playTabBarAnimation()
        self.curSelectedIndex = self.selectedIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.title == "" { // 扫码
            let scanVC = NYSScanViewController.init()
            let navVC = NYSBaseNavigationController.init(rootViewController: scanVC)
            navVC.modalPresentationStyle = .fullScreen
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromBottom
            view.window?.layer.add(transition, forKey: kCATransition)
            
            self.present(navVC, animated: false, completion: nil)
            return false
        }
        return true
    }
    
    /// 转场动画
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transform.selectedIndex = tabBarController.viewControllers!.firstIndex(of: toVC)!
        transform.preIndex = tabBarController.viewControllers!.firstIndex(of: fromVC)!
        return transform
    }
    
    
    /// 停止Lottie动画
    func stopTabBarAnimation() {
        for view in tabBar.subviews {
            if let tabBarButton = view as? UIControl, let animationView = tabBarButton.subviews.first as? LOTAnimationView {
                animationView.stop()
                animationView.removeFromSuperview()
            }
        }
    }
    
    /// 播放Lottie动画
    func playTabBarAnimation() {
        if self.selectedIndex == self.curSelectedIndex || self.selectedIndex == 2 {
            return
        }
        
        let tabbarButton = self.tabBar.subviews[self.selectedIndex + 1]
        let animationJsons = ["bill","goods","","service","myself"]
        let animatonView = tabbarButton.subviews.first
        animatonView?.isHidden = true
        let animation = LOTAnimationView(name: animationJsons[self.selectedIndex], bundle: Bundle.main)
        animation.frame = animatonView!.frame
        tabbarButton.addSubview(animation)
        animation.play { animationFinished in
            animatonView?.isHidden = false
            animation.stop()
            animation.removeFromSuperview()
        }
    }
    
    func createTabBarViewControllers() -> [UINavigationController] {
        let oneVC = NYSHomeViewController()
        oneVC.tabBarItem.title = "首页"
        oneVC.tabBarItem.image = UIImage.init(named: "Home_28")
        oneVC.tabBarItem.selectedImage = UIImage.init(named: "Home_Selected_28")?.withRenderingMode(.automatic)
        let oneNav = NYSBaseNavigationController.init(rootViewController: oneVC)
        
        let twoVC = NYSMissionViewController()
        twoVC.tabBarItem.title = "Home"
        twoVC.tabBarItem.image = UIImage.init(named: "Home_28")
        twoVC.tabBarItem.selectedImage = UIImage.init(named: "Home_Selected_28")?.withRenderingMode(.automatic)
        let twoNav = NYSBaseNavigationController.init(rootViewController: twoVC)
        
        let threeVC = NYSScanViewController()
        threeVC.tabBarItem.title = ""
        threeVC.tabBarItem.image = UIImage.init(named: "Scan-green")?.withRenderingMode(.automatic)
        threeVC.tabBarItem.selectedImage = UIImage.init(named: "Scan-green")?.withRenderingMode(.automatic)
        let threeNav = NYSBaseNavigationController.init(rootViewController: threeVC)
        
        let fourVC = NYSServiceViewController()
        fourVC.tabBarItem.title = "New"
        fourVC.tabBarItem.image = UIImage.init(named: "New_28")
        fourVC.tabBarItem.selectedImage = UIImage.init(named: "New_Selected_28")?.withRenderingMode(.automatic)
        let fourNav = NYSBaseNavigationController.init(rootViewController: fourVC)
        
        let fiveVC = NYSMineViewController()
        fiveVC.tabBarItem.title = "Open"
        fiveVC.tabBarItem.image = UIImage.init(named: "Open_28")
        fiveVC.tabBarItem.selectedImage = UIImage.init(named: "Open_Selected_28")?.withRenderingMode(.automatic)
        let fiveNav = NYSBaseNavigationController.init(rootViewController: fiveVC)
        
        return [twoNav, fourNav, fiveNav]
    }
    
}
