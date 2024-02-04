//
//  FIRVersionCheck.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

@interface FIRVersionCheck : NSObject

/**
 *  配置 api_token，根据 bundle id 自动匹配应用
 */
+ (void)setAPIToken:(NSString *)APIToken;

/**
*  配置 targetController，弹窗的控制器
*/
+ (void)setTargetController:(UIViewController *)targetController;

/**
 *  配置 app_id 和 api_token
 */
+ (void)setAppID:(NSString *)appID APIToken:(NSString *)APIToken;

/**
 *  根据当前项目 build 版本号检查新版本，有则自动弹出 UIAlertView 提醒
 */
+ (void)check;

@end
