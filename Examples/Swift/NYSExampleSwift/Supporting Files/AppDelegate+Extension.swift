//
//  AppDelegate+Extension.swift
//  NYSExampleSwift
//
//  Created by niyongsheng on 2024/2/7.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import Foundation

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
