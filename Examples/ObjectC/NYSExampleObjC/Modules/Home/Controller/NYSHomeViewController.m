//
//  NYSHomeViewController.m
//  NYSExampleObjC
//
//  Created by niyongsheng on 2024/2/4.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

#import "NYSHomeViewController.h"

@interface NYSHomeViewController ()

@end

@implementation NYSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Home";
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }
    
    [self.view addSubview:self.tableView];
    
    [self initNavItem];
}

- (void)initNavItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"notification_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:nil];
    WS(weakSelf);
    [rightItem setActionBlock:^(id _Nonnull sender) {
        [weakSelf.navigationController pushViewController:NYSBaseViewController.new animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -120;
}

@end
