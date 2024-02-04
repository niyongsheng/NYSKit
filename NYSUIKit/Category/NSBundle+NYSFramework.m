//
//  NSBundle+NYSFramework.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NSBundle+NYSFramework.h"
#import "NYSUIKit/NYSUIKitUtilities.h"

@implementation NSBundle (NYSFramework)

+ (UIImage *)nys_imageForKey:(NSString *)key {
    return [UIImage imageNamed:key inBundle:[self nys_refreshBundle] compatibleWithTraitCollection:nil];
}

+ (UIImage *)nys_imageForKey:(NSString *)key type:(NSString *)type {
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self nys_refreshBundle] pathForResource:key ofType:type]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return image;
}

+ (NSString *)nys_localizedStringForKey:(NSString *)key value:(nullable NSString *)value {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else if ([language hasPrefix:@"lao"]) {
            language = @"lao";
        } else {
            language = @"en";
        }

        bundle = [NSBundle bundleWithPath:[[NSBundle nys_refreshBundle] pathForResource:language ofType:@"lproj"]];
    }
    NSString *str = [bundle localizedStringForKey:key value:value table:nil];
    return str;
}

+ (NSString *)nys_localizedStringForKey:(NSString *)key {
    return [self nys_localizedStringForKey:key value:@"nil"];
}

+ (instancetype)nys_refreshBundle {
    return [self nys_refreshBundle:@"NYSUIKit"];
}

+ (instancetype)nys_refreshBundle:(NSString *)bundleName {
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
#ifdef SWIFT_PACKAGE
        NSBundle *containnerBundle = SWIFTPM_MODULE_BUNDLE;
#else
        NSBundle *containnerBundle = [NSBundle bundleForClass:[NYSUIKitUtilities class]];
#endif
        refreshBundle = [NSBundle bundleWithPath:[containnerBundle pathForResource:bundleName ofType:@"bundle"]];
    }
    return refreshBundle;
}

@end
