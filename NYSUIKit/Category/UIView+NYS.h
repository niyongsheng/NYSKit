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

/// 添加加载动画
+ (UIView*)loadingAnimation;
/// 移除加载动画
+ (void)removeLoadingAnimation;

@property (nonatomic, copy) NYSTapActionBlock tapActionBlock;
/// 添加点击事件
- (void)addTapActionWithBlock:(NYSTapActionBlock)block;

@end
