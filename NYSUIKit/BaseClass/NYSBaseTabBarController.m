//
//  NYSBaseTabBarController.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSBaseTabBarController.h"
#import "NYSBaseNavigationController.h"
#import "LEETheme.h"
#import "NYSUIKitPublicHeader.h"

@interface NYSBaseTabBarController () <UITabBarControllerDelegate>

@end

@implementation NYSBaseTabBarController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTheme];
    self.delegate = self;
}

- (void)configTheme {
    if (@available(iOS 13.0, *)) {
        self.tabBar.lee_theme.LeeConfigTintColor(@"app_theme_color");
    } else {
        self.view.lee_theme.LeeConfigBackgroundColor(@"normal_corner_style_bg_color");
        self.tabBar.lee_theme
            .LeeConfigBarTintColor(@"normal_corner_style_bg_color")
            .LeeConfigTintColor(@"app_theme_color");
    }
}

- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];

    if (self.isResetTabBarItemStyle) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        /* appearance.backgroundColor = [UIColor whiteColor]; */
        appearance.shadowImage = [self imageWithColor:UIColor.clearColor size:CGSizeMake(1, 1)];
        childController.tabBarItem.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            childController.tabBarItem.scrollEdgeAppearance = appearance;
        }
    }
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setRoundedCornerWithCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius {
    if (!self.tabBar) {
        return;
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.tabBar.bounds byRoundingCorners:cornerRadius cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
    self.tabBar.layer.mask = maskLayer;
}


#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.isOpenGradualAnimation) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5f];
        [animation setType:@"rippleEffect"];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [tabBarController.view.layer addAnimation:animation forKey:@"switchView"];
    }
    
    return YES;
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
}

- (void)animationWithIndex:(NSInteger)index {
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    switch (self.tabBarInteractionEffectStyle) {
        case NYSBaseTabBar_InteractionEffectStyleNone:{ // 无
        }break;
        case NYSBaseTabBar_InteractionEffectStyleSpring:{ // 放大放小
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
            animation.duration = 0.6;
            animation.calculationMode = kCAAnimationCubic;
            
        }break;
        case NYSBaseTabBar_InteractionEffectStyleShake:{ // 摇动
            animation.keyPath = @"transform.rotation";
            CGFloat angle = M_PI_4 / 10;
            animation.values = @[@(-angle), @(angle), @(-angle)];
            animation.duration = 0.2f;
        }break;
        case NYSBaseTabBar_InteractionEffectStyleAlpha:{ // 透明
            animation.keyPath = @"opacity";
            animation.values = @[@1.0,@0.7,@0.5,@0.7,@1.0];
            animation.duration = 0.6;
        }break;
        default: break;
    }
    [[tabbarbuttonArray[index] layer] addAnimation:animation forKey:nil];
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    if (@available(iOS 13.0, *)) {
        [feedBackGenertor impactOccurredWithIntensity:0.75];
    } else {
        [feedBackGenertor impactOccurred];
    }
}

#pragma mark - auto rotate
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

@end
