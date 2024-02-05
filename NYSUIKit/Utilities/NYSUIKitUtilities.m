//
//  NYSUIKitUtilities.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSUIKitUtilities.h"

// 判断iphoneX
#define isIphonex ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

static NSString *const NYSUserLanguageKey = @"NYSUserLanguageKey";
#define STANDARD_USER_DEFAULT  [NSUserDefaults standardUserDefaults]

@implementation NYSUIKitUtilities

+ (CGFloat)nys_navigationHeight {
    return 44.f;
}

+ (CGFloat)nys_statusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [connectedScenes anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        CGFloat height = statusBarManager.statusBarFrame.size.height;
        return height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (CGFloat)nys_navigationFullHeight {
    return [self nys_statusBarHeight] + 44;
}

+ (CGFloat)nys_safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        CGFloat h = window.safeAreaInsets.bottom;
        return h;
        
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        CGFloat h = window.safeAreaInsets.bottom;
        return h;
    }
    
    if (isIphonex) {
        return 34.0f;
    } else {
        return 0;
    }
}

/// 读取包中图片资源
/// - Parameter name: 名称
/// mark: 如果bundle获取到的一直是app的资源名，需要把Framework修改成动态库 MACH_O_TYPE = dynamic
+ (nullable UIImage *)imageNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

/// 读取.bundle中图片资源
/// - Parameter name: 图片名名称
+ (nullable UIImage *)imageBundleNamed:(NSString *)name {
    NSBundle*bundle = [NSBundle bundleWithPath:@"NYSUIKit.bundle/image"];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (void)setUserLanguage:(NSString *)userLanguage {
    // 跟随手机系统
    if (!userLanguage.length) {
        [self resetSystemLanguage];
        return;
    }
    // 用户自定义
    [STANDARD_USER_DEFAULT setValue:userLanguage forKey:NYSUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:@[userLanguage] forKey:@"AppleLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
}

+ (NSString *)userLanguage {
    return [STANDARD_USER_DEFAULT valueForKey:NYSUserLanguageKey];
}

/**
 重置系统语言
 */
+ (void)resetSystemLanguage {
    [STANDARD_USER_DEFAULT removeObjectForKey:NYSUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:nil forKey:@"AppleLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
}

@end
