//
//  NYSHomeViewController.m
//  NYSExampleObjC
//
//  Created by niyongsheng on 2024/2/4.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

#import "NYSHomeViewController.h"
#import "NYSNoticeViewController.h"

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"notification_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemOnclicked)];
}

- (void)rightItemOnclicked {
    [self.navigationController pushViewController:NYSNoticeViewController.new animated:YES];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -120;
}

@end
