//
//  NSBundle+NYSLanguageSwitch.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (NYSLanguageSwitch)
+ (BOOL)isChineseLanguage;

+ (NSString *)currentLanguage;
@end

NS_ASSUME_NONNULL_END
