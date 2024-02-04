//
//  UIImage+NYS.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (NYS)
/// 修改图片颜色
/// @param color 颜色
- (UIImage *)imageChangeColor:(UIColor*)color;

/// 获取用户名头像
/// @param name 昵称
/// @param size 尺寸
+ (UIImage *)createNikeNameImageName:(NSString *)name imageSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
