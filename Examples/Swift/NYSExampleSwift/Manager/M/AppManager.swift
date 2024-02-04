//
//  AppManager.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//
//  应用信息管理器

import UIKit
import NYSKit
import NYSUIKit
import RxSwift
import ExCodable
import Disk

let cachePath: String = "userinfo.json"
final class AppManager {
    
    var seq: Int = 0
    private let disposeBag = DisposeBag()
    let userinfoSubject = PublishSubject<NYSUserInfo>()
    
    /// 用户信息
    private(set) var userInfo: NYSUserInfo = {
        var defaultUserInfo = NYSUserInfo()
        if Disk.exists(cachePath, in: .documents) {
            let userinfo = try? Disk.retrieve(cachePath, from: .documents, as: NYSUserInfo.self)
            defaultUserInfo = userinfo!
        }
        return defaultUserInfo
    }() {
        didSet {
            do {
                try Disk.save(userInfo, to: .documents, as: cachePath)
                userinfoSubject.onNext(userInfo)
            } catch {
                NYSTools.log("Failed to cache user info: \(error)")
            }
        }
    }
    
    /// 是否登录
    var isLogin: Bool {
        return !String.isBlank(string: self.token)
    }
    
    /// 秘钥
    @UserDefault(key: kToken, defaultValue: nil)
    private(set) var token: String?
    
    /// 单例
    static let shared = AppManager()
    
    /// 私有化初始化方法
    private init() {
        _ = AlertManager.shared
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: NNotificationTokenInvalidation)).subscribe(onNext: { notification in
            AlertManager.shared.showLogin()
        }).disposed(by: disposeBag)
    }
}

extension AppManager {
    
    enum AppLoginType: Int {
        case unknown = 0           // 未知
        case qq                    // QQ登录
        case weChat                // 微信登录
        case password              // 密码登录
        case oncecode              // 短信登录
        case apple                 // Sign In With Apple
        case verification          // 一键认证
    }
    
    typealias AppManagerCompletion = ((_ isSuccess:Bool, _ userInfo:NYSUserInfo?, _ error:Error?) -> Void)?
    
    /// 登入
    func loginHandler(loginType: AppLoginType, params: [String: Any], completion: AppManagerCompletion) {
        NYSNetRequest.mockRequest(withParameters: "login_data.json",
                                  isCheck: true,
                                  remark: "登录",
                                  success: { [weak self] response in
            if let token = response?["token"] as? String {
                self?.token = token
                completion?(true, nil, nil)
            } else {
                completion?(false, nil, NSError(domain: "AppManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token not found in response"]))
            }
        }, failed: { error in
            completion?(false, nil, error)
            NYSTools.log("Error: \(String(describing: error))")
        })
    }
    
    /// 登出
    func logoutHandler() {
        // 1.清除Token
        $token.remove()
        NYSKitManager.shared().token = nil
        try? Disk.clear(.documents)
        
        // 2.清除标签别名
        JPUSHService.cleanTags(nil, seq: self.seq)
        JPUSHService.deleteAlias(nil, seq: self.seq)
        
        // 3.加载登录页
        let rootVC = NYSAccountViewController.init()
        let navVC = NYSBaseNavigationController.init(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController?.present(navVC, animated: true, completion: nil)
        }
    }
}

extension AppManager {
    
    /// 刷新用户信息
    /// - Parameter completion: 回调
    func refreshUserInfo(completion: AppManagerCompletion) {
        if !isLogin {
            completion?(false, nil, nil)
            return
        }
        
        NYSNetRequest.mockRequest(withParameters: "userinfo_data.json",
                                  isCheck: true,
                                  remark: "重载用户信息",
                                  success: { [weak self] response in
            
            do {
                let userinfo = try response?.decoded() as NYSUserInfo?
                self?.userInfo = userinfo ?? NYSUserInfo()
    
                let tagSet: Set<String> = Set(userinfo!.tagArr)
                JPUSHService.setTags(tagSet, completion: { iResCode, iTags, seq in
                    NYSTools.log("设置标签：\(iResCode == 0 ? "成功" : "失败")")
                }, seq: self?.seq ?? 0)

                JPUSHService.setAlias(userinfo!.alias!, completion: { iResCode, iAlias, seq in
                    NYSTools.log("设置别名：\(iResCode == 0 ? "成功" : "失败")")
                }, seq: self?.seq ?? 0)
                
                completion?(true, self?.userInfo, nil)
                
            } catch {
                AlertManager.shared.showAlert(title: "解码失败：\(error)")
            }
            
        }, failed:{ error in
            completion?(false, nil, nil)
            NYSTools.log("Error: \(String(describing: error))")
        })
    }
    
}
