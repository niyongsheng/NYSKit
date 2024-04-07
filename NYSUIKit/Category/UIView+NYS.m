//
//  UIView+NYS.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "UIView+NYS.h"
#import "UIImage+NYS.h"
#import "NYSUIKitUtilities.h"
#import <objc/runtime.h>

#define kLinePix ( 1 / [UIScreen mainScreen].scale)

static const char *NYSTapActionKey = "NYSTapActionKey";

@implementation UIView (NYS)

#pragma mark - StoryBoard tool
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

#pragma mark - Loading Animation
+ (UIView*)showLoadingWithImage:(UIImage *)image {
    UIWindow *keywindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keywindow = window;
            break;
        }
    }
    
    CGFloat width = keywindow.frame.size.width;
    CGFloat height = keywindow.frame.size.height;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeLoadingAnimation:)]];
    bgView.userInteractionEnabled = YES;
    bgView.alpha = 0;
    
    UIImageView *animation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    animation.center = CGPointMake(width / 2.0, height / 2.0);
    animation.contentMode = UIViewContentModeCenter;
    [animation setImage:image ? image : [[NYSUIKitUtilities imageNamed:@"waiting_icon"] imageByResizeToSize:CGSizeMake(40, 40)]];
    [bgView addSubview:animation];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.25; // 旋转一周所需时间
    rotationAnimation.repeatCount = HUGE_VALF; // 无限循环
    [animation.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [keywindow addSubview:bgView];
    [UIView transitionWithView:bgView duration:0.75 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        bgView.alpha = 1.0;
    } completion:nil];
    
    return bgView;
}

+ (UIView*)showLoadingWithTintColor:(UIColor *)tintColor {
    UIWindow *keywindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keywindow = window;
            break;
        }
    }
    
    CGFloat width = keywindow.frame.size.width;
    CGFloat height = keywindow.frame.size.height;
    UIBlurEffectStyle blurEffectStyle = UIBlurEffectStyleLight;
    UIColor *color = UIColor.grayColor;
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            blurEffectStyle = UIBlurEffectStyleDark;
            color = UIColor.whiteColor;
        } else {
            blurEffectStyle = UIBlurEffectStyleLight;
        }
    }
    UIVisualEffectView *bgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:blurEffectStyle]];
    bgView.frame = CGRectMake(0, 0, width, height);
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeLoadingAnimation:)]];
    bgView.userInteractionEnabled = YES;
    bgView.alpha = 0;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    activityIndicator.color = tintColor ? tintColor : color;
    activityIndicator.center = CGPointMake(width / 2.0, height / 2.0);
    [activityIndicator startAnimating];
    [bgView.contentView addSubview:activityIndicator];
    
    [keywindow addSubview:bgView];
    [UIView transitionWithView:bgView duration:0.75 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        bgView.alpha = 1.0;
    } completion:nil];
    
    return bgView;
}

+ (void)removeLoadingAnimation:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.75 animations:^{
        gesture.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [gesture.view removeFromSuperview];
    }];
}

#pragma mark - Tap Action
- (NYSTapActionBlock)tapActionBlock {
    return objc_getAssociatedObject(self, NYSTapActionKey);
}

- (void)setTapActionBlock:(NYSTapActionBlock)tapActionBlock {
    objc_setAssociatedObject(self, NYSTapActionKey, tapActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addTapActionWithBlock:(NYSTapActionBlock)block {
    self.tapActionBlock = block;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (self.tapActionBlock) {
        self.tapActionBlock(self);
    }
}

@end
