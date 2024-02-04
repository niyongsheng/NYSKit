//
//  ThemeManager.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DAY                         @"day"
#define NIGHT                       @"night"

NS_ASSUME_NONNULL_BEGIN

@interface ThemeManager : NSObject

+ (ThemeManager *)sharedThemeManager;

/// 主题配置
- (void)configTheme;

/// 初始化主题切换气泡
- (void)initBubble:(UIWindow *)window;

/// 切换主题
- (void)changeTheme:(UIWindow *)window;

/// 设置主题
/// @param tag 主题标签
- (void)setThemeWithTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
