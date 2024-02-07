//
//  NYSTabBarViewController.m
//  NYSExampleObjC
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSTabBarViewController.h"
#import "NYSHomeViewController.h"
#import "NYSNewViewController.h"
#import "NYSOpenViewController.h"

@interface NYSTabBarViewController ()

@end

@implementation NYSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 点击动画
    self.tabBarInteractionEffectStyle = NYSBaseTabBar_InteractionEffectStyleSpring;
    self.isResetTabBarItemStyle = YES;
    self.isOpenGradualAnimation = YES;
    
    NYSHomeViewController *homeVC = [NYSHomeViewController new];
    homeVC.tabBarItem.title = @"Home";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"Home_28"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"Home_Selected_28"];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:homeVC]];
    
    NYSNewViewController *NewVC = [NYSNewViewController new];
    NewVC.tabBarItem.title = @"New";
    NewVC.tabBarItem.image = [UIImage imageNamed:@"New_28"];
    NewVC.tabBarItem.selectedImage = [UIImage imageNamed:@"New_Selected_28"];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:NewVC]];
    
    NYSOpenViewController *OpenVC = [NYSOpenViewController new];
    OpenVC.tabBarItem.title = @"Open";
    OpenVC.tabBarItem.image = [UIImage imageNamed:@"Open_28"];
    OpenVC.tabBarItem.selectedImage = [UIImage imageNamed:@"Open_Selected_28"];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:OpenVC]];
}

@end
