//
//  UIButton+NYS.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define defaultInterval 1  // 默认时间间隔

typedef void (^ButtonBlock)(UIButton *button);

@interface UIButton (NYS)
/// 点击响应范围
/// @param edge 范围
- (void)enlargeTouchEdge:(UIEdgeInsets)edge;

/// 按钮点击时间间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;
/// 按钮不需要被hook时传YES
@property (nonatomic, assign) BOOL isIgnore;

/// 开始加载动画
- (void)startLoading;
/// 停止加载动画
- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
