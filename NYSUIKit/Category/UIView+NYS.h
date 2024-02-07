//
//  UIView+NYS.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NYSTapActionBlock)(UIView *view);

IB_DESIGNABLE
@interface UIView (NYS)
/**
 StoryBoard tool
 */
/// 边线颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/// 边线宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/// 圆角半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/// 显示加载动画(毛玻璃效果)
/// - Parameter tintColor: 指示器颜色
+ (UIView*)showLoadingWithTintColor:(UIColor *)tintColor;

/// 显示加载动画
/// - Parameter image: 自定义旋转图
+ (UIView*)showLoadingWithImage:(UIImage *)image;

@property (nonatomic, copy) NYSTapActionBlock tapActionBlock;
/// 添加点击事件
- (void)addTapActionWithBlock:(NYSTapActionBlock)block;

@end
