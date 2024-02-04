//
//  AlertManager.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/22.
//
//  弹框提醒管理器

import Foundation
import RxSwift
import FFPopup
import JDStatusBarNotification

final class AlertManager {
    
    let delay = 1.5
    let showInDuration = 0.4
    let dismissOutDuration = 0.3
    private let disposeBag = DisposeBag()
    
    /// 登录弹窗
    private lazy var appAlertView: AppAlertView = {
        let appAlertView = AppAlertView(frame: CGRect(x: 0, y: 0, width: NScreenWidth * 0.8, height: RealValueX(x: 165)))
        return appAlertView
    }()
    
    /// 分享弹窗
    private lazy var appShareView: AppShareView = {
        let appShareView = AppShareView(frame: CGRect(x: 0, y: 0, width: NScreenWidth, height: RealValueX(x: 265)))
        return appShareView
    }()
    
    /// 富文本弹窗
    private lazy var textAlertView: NYSTextAlertView = {
        let textAlertView = NYSTextAlertView(frame: CGRect(x: 0, y: 0, width: NScreenWidth * 0.85, height: NScreenHeight * 0.65))
        return textAlertView
    }()
    
    /// 单例
    static let shared = AlertManager()
    
    /// 私有化初始化方法
    private init() {
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: NNotificationNetworkChange)).subscribe(onNext: { notification in
            var imageView = UIImageView()
            /** AFNetworkReachabilityStatus */
            if let status = notification.object as? Int {
                switch status {
                case -1:
                    NotificationPresenter.shared.present("网络状态未知", includedStyle: .defaultStyle, duration: self.delay)
                    imageView = UIImageView(image: UIImage(systemName: "xmark.icloud"))
                    break
                case 0:
                    NotificationPresenter.shared.present("网络不可用", includedStyle: .defaultStyle, duration: self.delay)
                    imageView = UIImageView(image: UIImage(systemName: "wifi.slash"))
                    break
                case 1:
                    NotificationPresenter.shared.present("移动网络", includedStyle: .defaultStyle, duration: self.delay)
                    imageView = UIImageView(image: UIImage(systemName: "antenna.radiowaves.left.and.right.circle.fill"))
                    break
                case 2:
                    NotificationPresenter.shared.present("WiFi网络", includedStyle: .defaultStyle, duration: self.delay)
                    imageView = UIImageView(image: UIImage(systemName: "wifi.circle.fill"))
                    break
                default:
                    break
                }
                imageView.tintColor = NAppThemeColor
                NotificationPresenter.shared.displayLeftView(imageView)
            }
            
        }).disposed(by: disposeBag)
    }
}

// pramga mark - 应用弹窗
extension AlertManager {
    
    func showLogin() {
        showAlert(title: "温馨提示", content: "您还没有登陆！", icon: nil, confirmButtonTitle: "去登录", cancelBtnTitle: "取消") { popup, action, obj in
            if action == .confirm {
                popup.dismiss(animated: true)
                AppManager.shared.logoutHandler()
            }
        }
    }
    
    func showAlert(title: String?) {
        showAlert(title: title, content: nil, icon: nil, confirmButtonTitle: "确定", cancelBtnTitle: nil, complete: nil)
    }
    
    func showAlert(title: String?, complete: ((FFPopup, AppAlertView.AppAlertAction, Any?) -> Void)? = nil) {
        showAlert(title: title, content: nil, icon: nil, confirmButtonTitle: "确定", cancelBtnTitle: nil, complete: complete)
    }
    
    func showAlert(title: String?, content: String?, icon: UIImage?, confirmButtonTitle: String?, cancelBtnTitle: String?, complete: ((FFPopup, AppAlertView.AppAlertAction, Any?) -> Void)? = nil) {
        
        let popup = FFPopup(contentView: appAlertView, showType: .growIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.showInDuration = showInDuration
        popup.dismissOutDuration = dismissOutDuration
        popup.show(layout: FFPopupLayout(horizontal: .center, vertical: .center))
        
        appAlertView.popup = popup
        appAlertView.complete = complete
        appAlertView.configure(title: title, content: content, icon: icon, confirmButtonTitle: confirmButtonTitle, cancelBtnTitle: cancelBtnTitle)
        
        let w = appAlertView.width - 30.0
        let titleHeight = title?.heightWithConstrainedWidth(width: w, font: UIFont.boldSystemFont(ofSize: 16)) ?? 0
        let contentHeight = content?.heightWithConstrainedWidth(width: w, font: UIFont.systemFont(ofSize: 17)) ?? 0
        appAlertView.height = 125.0 + (icon?.size.height ?? 0) + titleHeight + contentHeight
    }
    
}

// pramga mark - 分享弹窗
extension AlertManager {
    
    func showShare(content: Any?) {
        showShare(content: content, icon: nil, confirmButtonTitle: "分享", complete: nil)
    }
    
    func showShare(content: Any?, icon: UIImage?, confirmButtonTitle: String?, complete: ((FFPopup, NYSRootAlertView.AppAlertAction, AppShareView.AppShareType, Any?) -> Void)? = nil) {
        
        let popup = FFPopup(contentView: appShareView, showType: .slideInFromBottom, dismissType: .slideOutToBottom, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.showInDuration = showInDuration
        popup.dismissOutDuration = dismissOutDuration
        popup.show(layout: FFPopupLayout(horizontal: .center, vertical: .bottom))
        
        appShareView.popup = popup
        appShareView.complete = complete
        appShareView.configure(content: nil, icon: nil, confirmButtonTitle: "立即分享")
    }
    
}


// pramga mark - 逾期弹窗
extension AlertManager {
    
    fileprivate func showCustomAlert(_ appOverdueAlertView: NYSOverdueAlertView, _ index: Int?, _ duration: CGFloat, _ inView: UIView?, _ text: String?, _ complete: ((FFPopup, NYSRootAlertView.AppAlertAction, Any?) -> Void)?) {
        appOverdueAlertView.tag = index ?? 0
        let popup = FFPopup(contentView: appOverdueAlertView, showType: .bounceInFromBottom, dismissType: .bounceOutToBottom, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        popup.maskType = .none
        popup.showInDuration = showInDuration * 1.5
        popup.dismissOutDuration = dismissOutDuration
        
        var targetView: UIView
        if inView == nil {
            targetView = UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIView()
        } else {
            targetView = inView!
        }
        
        // 计算堆叠位置
        let popupCount = targetView.subviews.filter { $0.isKind(of: FFPopup.self) }.count
        let y = NScreenHeight - NBottomHeight - NAppSpace - appOverdueAlertView.height/2 - CGFloat(popupCount) * (appOverdueAlertView.height + NAppSpace)
        
        if targetView.viewWithTag(index ?? 0) != nil { // 防止重复弹出
            return
        }
        
        popup.show(center: CGPoint(x: NScreenWidth/2, y: y), inView: targetView, duration: duration)
        
        appOverdueAlertView.popup = popup
        appOverdueAlertView.textL.text = text
        appOverdueAlertView.complete = complete
    }
    
    func showOverdueAlert(text: String?, index: Int?, duration: CGFloat = 0, inView: UIView?, complete: ((FFPopup, NYSRootAlertView.AppAlertAction, Any?) -> Void)? = nil) {
        let overdueAlertView = NYSOverdueAlertView(frame: CGRect(x: 0, y: 0, width: NScreenWidth * 0.95, height: RealValueX(x: 45)))
        showCustomAlert(overdueAlertView, index, duration, inView, text, complete)
    }
}

// pramga mark - 富文本弹窗
extension AlertManager {
    
    func showTextAlert(attributedText: NSAttributedString, imageName: String = "winner", complete: ((FFPopup, AppAlertView.AppAlertAction, Any?) -> Void)? = nil) {
        
        let popup = FFPopup(contentView: textAlertView, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        popup.showInDuration = showInDuration * 1.2
        popup.dismissOutDuration = dismissOutDuration
        popup.show(layout: FFPopupLayout(horizontal: .center, vertical: .center))
        
        textAlertView.popup = popup
        textAlertView.complete = complete
        textAlertView.contentTV.attributedText = attributedText
        textAlertView.iconIV.image = UIImage(named: imageName)
    }
    
}
