//
//  NYSNewViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSNewViewController.h"

@interface NYSNewViewController ()

@end

@implementation NYSNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
    UIButton *themeBtn = [UIButton new];
    themeBtn.lee_theme
    .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
        [(UIButton *)item setTitle:@"Light" forState:UIControlStateNormal];
    })
    .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
        [(UIButton *)item setTitle:@"Dark" forState:UIControlStateNormal];
    });
    themeBtn.lee_theme.LeeConfigButtonTitleColor(@"common_nav_font_color_1", UIControlStateNormal);
    [[themeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[ThemeManager sharedThemeManager] changeTheme:NAppWindow];
    }];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:themeBtn];
    WS(weakSelf);
    [rightItem1 setActionBlock:^(id _Nonnull sender) {
        [weakSelf.webView reload];
    }];
    self.navigationItem.rightBarButtonItems = @[rightItem1, rightItem2];
    
    self.urlStr = GitHubURl;
    self.autoTitle = NO;
}

@end
