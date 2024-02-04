//
//  NYSBaseNavigationController.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSBaseNavigationController.h"
#import "NYSBaseViewController.h"
#import "NYSUIKitPublicHeader.h"
#import "LEETheme.h"

@interface NYSBaseNavigationController () <UINavigationControllerDelegate>

@end

@implementation NYSBaseNavigationController

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    //[navBar setBackgroundImage:[[UIImage imageWithColor:[UIColor whiteColor]] imageByBlurRadius:40 tintColor:nil tintMode:0 saturation:1 maskImage:nil] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    // delete bottom line
    [navBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationBar.prefersLargeTitles = NO;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    [self configTheme];
    self.delegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    id vc = self.topViewController;
    if ([vc isKindOfClass:NYSBaseViewController.class]) {
        return [vc customStatusBarStyle];
    } else {
        return UIStatusBarStyleDefault;
    }
}

/// theme config
- (void)configTheme {
    
    self.navigationBar.lee_theme
    .LeeAddCustomConfig(DAY, ^(UINavigationBar *bar) {
      
        bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
        if (@available(iOS 11.0, *)) {
            bar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],
            NSFontAttributeName : [UIFont fontWithName:@"DOUYU Font" size:30.0f]
            };
        }
    })
    .LeeAddCustomConfig(NIGHT, ^(UINavigationBar *bar) {
        
        bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
        if (@available(iOS 11.0, *)) {
            bar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                             NSFontAttributeName : [UIFont fontWithName:@"DOUYU Font" size:30.0f]
            };
        }
    });
}

#pragma mark - UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    // 设置导航栏返回按钮文字
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    /*
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    [back setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    */
    item.backBarButtonItem = back;
    
    return YES;
}

/// when push auto hidden tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/// navigation delegate hidden method
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if ([viewController isKindOfClass:[NYSBaseViewController class]]) {
        NYSBaseViewController *vc = (NYSBaseViewController *)viewController;
        if (vc.isHidenNaviBar) {
            [vc.navigationController setNavigationBarHidden:YES animated:animated];
        } else {
            [vc.navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if ([viewController isKindOfClass:[NYSBaseViewController class]]) {
        NYSBaseViewController *vc = (NYSBaseViewController *)viewController;
        if (vc.isHidenNaviBar) {
            [vc.navigationController setNavigationBarHidden:YES animated:animated];
        } else {
            [vc.navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
}

@end
