//
//  NYSUIKitUtilities.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSUIKitUtilities : NSObject
/// 顶部状态栏高度（包括安全区）
+ (CGFloat)nys_statusBarHeight;
/// 导航栏的高度
+ (CGFloat)nys_navigationHeight;
/// 状态栏+导航栏的高度
+ (CGFloat)nys_navigationFullHeight;
/// 底部安全高度
+ (CGFloat)nys_safeDistanceBottom;

/// 读取.xcassets中图片资源
/// - Parameter name: 图片名名称
+ (nullable UIImage *)imageNamed:(NSString *)name;

/// 读取.bundle中图片资源
/// - Parameter name: 图片名名称
+ (nullable UIImage *)imageBundleNamed:(NSString *)name;

/// 重置系统语言
+ (void)resetSystemLanguage;
/// 用户自定义使用的语言，当传nil时，等同于resetSystemLanguage
@property (class, nonatomic, strong, nullable) NSString *userLanguage;

@end

NS_ASSUME_NONNULL_END
