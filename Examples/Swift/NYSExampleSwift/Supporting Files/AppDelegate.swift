//
//  AppDelegate.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/4/23.
//

import UIKit
import FlexLib
import NYSUIKit
import IQKeyboardManagerSwift
#if DEBUG
import CocoaDebug
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化导航栏
        initNavigationBar()
        
        // 初始化键盘
        initIQKeyboard()
        
        // 初始化网络
        initNetwork()
        
        // 初始化窗口
        initWindow()
        
        // 初始化极光推送
        initJPush(launchOptions)

        return true
    }
}

extension AppDelegate {
    
    private func initNavigationBar() {
        WRNavigationBar.defaultNavBarBarTintColor = .white // 背景色
        WRNavigationBar.defaultNavBarTintColor = .black // 图标色
        WRNavigationBar.defaultNavBarTitleColor = .black // 标题色
        WRNavigationBar.defaultStatusBarStyle = .lightContent
        WRNavigationBar.defaultShadowImageHidden = true
    }
    
    func initIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
    }
    
    func initWindow() {
        FlexRestorePreviewSetting()
        if let path = Bundle.main.path(forResource: "system", ofType: "style") {
            FlexStyleMgr.instance().loadClassStyle(path)
        }
        
        ThemeManager.shared().configTheme()
        window = NYSBaseWindow(frame: UIScreen.main.bounds)
        _ = window?.lee_theme.leeConfigBackgroundColor("white_black_color")
        window?.rootViewController = NYSTabBarViewController()
        window?.makeKeyAndVisible()
        
        #if DEBUG
        ThemeManager.shared().initBubble(window!) // 悬浮球ThemeBtn
        showFPS() // 显示FPS
        showMemory() // 显示MU
        // CocoaDebug
        CocoaDebugSettings.shared.enableLogMonitoring = true
        CocoaDebugSettings.shared.mainColor = NAppThemeColor.toHexString()
        // 内测更新提醒
        NYSFirVersionCheck.setAPIToken(FirApiToken)
        NYSFirVersionCheck.setTargetController(self.window?.rootViewController)
        NYSFirVersionCheck.check()
        #endif
    }
    
    func initNetwork() {
        NYSKitManager.shared().host = Api_Base_Url
        NYSKitManager.shared().token = AppManager.shared.token
        NYSKitManager.shared().normalCode = "200,0"
        NYSKitManager.shared().tokenInvalidCode = "500"
        NYSKitManager.shared().msgKey = "msg"
        NYSKitManager.shared().isAlwaysShowErrorMsg = true
    }
    
    func showFPS() {
        let fpsLabel = YYFPSLabel.init()
        fpsLabel.bottom = NScreenHeight - NBottomHeight - 40
        fpsLabel.right = NScreenWidth - 10
        fpsLabel.sizeToFit()
        window?.addSubview(fpsLabel)
    }

    func showMemory() {
        let memLabel = NYSMemoryLabel.init()
        memLabel.bottom = NScreenHeight - NBottomHeight - 10
        memLabel.right = NScreenWidth - 10
        memLabel.sizeToFit()
        window?.addSubview(memLabel)
    }

}

extension AppDelegate {
    /// 获取当前显示的控制器
    func getCurrentViewController() -> UIViewController? {
        var result: UIViewController?
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let fromView = window.subviews[0]
            
            if let nextResponder = fromView.next {
                if nextResponder.isKind(of: UIViewController.self) {
                    result = nextResponder as? UIViewController
                    
                    if result?.navigationController != nil {
                        result = result?.navigationController
                    }
                } else {
                    result = window.rootViewController
                }
            }
        }
        return result
    }
    
    // MARK: - override Swift `print` method
    public func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = .white) {
#if DEBUG
        Swift.print(message)
        _SwiftLogHelper.shared.handleLog(file: file, function: function, line: line, message: message, color: color)
#endif
    }
}

extension AppDelegate: JPUSHRegisterDelegate, JPUSHInAppMessageDelegate {

    func initJPush(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
        NSInteger(UNAuthorizationOptions.sound.rawValue) |
        NSInteger(UNAuthorizationOptions.badge.rawValue) |
        NSInteger(UNAuthorizationOptions.provisional.rawValue)
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setInAppMessageDelegate(self)
        JPUSHService.setup(withOption: launchOptions, appKey: JPUSH_APPKEY, channel: JPUSH_CHANNEl, apsForProduction: IS_Prod, advertisingIdentifier: nil)
        JPUSHService.registrationIDCompletionHandler { resCode, registrationID in
            if resCode == 0 {
                self.print("registrationID获取成功：\(String(describing: registrationID))")
            } else {
                self.print("registrationID获取失败，code：\(String(describing: registrationID))")
            }
        }
    }
    
    // MARK - JPUSHRegisterDelegate
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: (() -> Void)) {
        let userInfo = response.notification.request.content.userInfo
        let request = response.notification.request
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        print(request)
        completionHandler()
    }
    
    // 前台得到的的通知
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: ((Int) -> Void)) {
        let userInfo = notification.request.content.userInfo
        let request = notification.request
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        print(request)
        completionHandler(Int(UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
        
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]?) {
        print("receive notification authorization status:\(status), info:\(String(describing: info))")
    }
    
    // MARK - JPushInMessageDelegate  
    func jPush(inAppMessageDidShow inAppMessage: JPushInAppMessage) {
        
    }
    
    func jPush(inAppMessageDidClick inAppMessage: JPushInAppMessage) {
        
    }
}
