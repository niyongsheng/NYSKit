//
//  WSScrollLabel.h
//  滚动的文字
//
//  Created by iMac on 16/9/21.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WSScrollLabelViewDidAppearNotification            @"WSScrollLabelViewDidAppearNotification"

@interface WSScrollLabel : UIView

@property (nonatomic, strong) NSString *text; /**< 文字*/
@property (nonatomic, strong) UIColor *textColor; /**< 字体颜色 默认白色*/
@property (nonatomic, strong) UIFont *textFont; /**< 字体大小 默认25*/

/**< 首尾间隔 默认25*/
@property (nonatomic, assign) CGFloat space;
/**< 滚动持续时间 默认5*/
@property (nonatomic, assign) CGFloat duration;
/**< 每次开始滚动前暂停的间隔 默认2s*/
@property (nonatomic, assign) NSTimeInterval pauseTimeIntervalBeforeScroll;

- (void)addCycleScrollObserverNotification;


@end
