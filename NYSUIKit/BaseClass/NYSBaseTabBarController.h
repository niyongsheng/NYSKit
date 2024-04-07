//
//  NYSBaseTabBarController.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NYSBaseTabBarInteractionEffectStyle) {
    NYSBaseTabBar_InteractionEffectStyleNone,     // 无 默认
    NYSBaseTabBar_InteractionEffectStyleSpring,   // 放大放小
    NYSBaseTabBar_InteractionEffectStyleShake,    // 摇动动画效果
    NYSBaseTabBar_InteractionEffectStyleAlpha     // 透明动画效果
};

@interface NYSBaseTabBarController : UITabBarController
/// 点击动画类型
@property (nonatomic, assign) NYSBaseTabBarInteractionEffectStyle tabBarInteractionEffectStyle;
/// 是否启用渐变切换
@property (nonatomic, assign) BOOL isOpenGradualAnimation;
/// 是否重置tabBarItem样式
@property (nonatomic, assign) BOOL isResetTabBarItemStyle;

- (void)setRoundedCornerWithCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
