//
//  UIColor+NYS.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientDirection) {
    GradientDirectionHorizontal,
    GradientDirectionVertical,
};

@interface UIColor (NYS)

/// 通过十六进制字符串创建UIColor
/// @param hexString 色值
/// @param alpha 透明度
+ (instancetype)initWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (instancetype)initWithHexString:(NSString *)hexString;

/// 随机颜色
+ (instancetype)randomColor;

/// 将颜色转换为十六进制表示
- (NSString *)hexString;

/// 创建渐变色图层
/// @param startColor 开始色
/// @param endColor 结束色
/// @param direction 渐变方向
+ (CAGradientLayer *)gradientFromColor:(UIColor *)startColor toColor:(UIColor *)endColor direction:(GradientDirection)direction;


@end
