//
//  NSBundle+NYSFramework.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (NYSFramework)

/// 读取图片
+ (UIImage *)nys_imageForKey:(NSString *)key;
+ (UIImage *)nys_imageForKey:(NSString *)key type:(NSString *)type;

/// 读取国际化字符串
+ (NSString *)nys_localizedStringForKey:(NSString *)key value:(nullable NSString *)value;
+ (NSString *)nys_localizedStringForKey:(NSString *)key;

+ (instancetype)nys_refreshBundle;
+ (instancetype)nys_refreshBundle:(NSString *)bundleName;
@end

NS_ASSUME_NONNULL_END
