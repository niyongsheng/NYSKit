//
//  NYSTabBarViewController.m
//  BaseIOS
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSTabBarViewController.h"

@interface NYSTabBarViewController ()

@end

@implementation NYSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.VCArray = @[
        @{@"vc" : @"NYSConversationListViewController",
          @"normalImg" : @"Home_28",
          @"selectImg" : @"Home_Selected_28",
          @"itemTitle" : @"Home"},
        @{@"vc" : @"NYSNewViewController",
          @"normalImg" : @"New_28",
          @"selectImg" : @"New_Selected_28",
          @"itemTitle" : @"New"},
        @{@"vc": @"NYSOpenViewController",
          @"normalImg" : @"Open_28",
          @"selectImg" : @"Open_Selected_28",
          @"itemTitle" : @"Open"}
    ];
}

@end
