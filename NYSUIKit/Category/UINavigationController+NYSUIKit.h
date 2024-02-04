//
//  UINavigationController+NYSUIKit.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (NYSUIKit)

/// 回退到指定控制器
/// - Parameters:
///   - aClass: 类名
///   - animated: 动画
- (void)popToViewControllerClass:(Class)aClass animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
