//
//  NYSNoticeViewController.m
//  NYSExampleObjC
//
//  Created by niyongsheng on 2024/2/7.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

#import "NYSNoticeViewController.h"

@interface NYSNoticeViewController ()

@end

@implementation NYSNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [UIView showLoadingWithTintColor:nil];
}

@end
