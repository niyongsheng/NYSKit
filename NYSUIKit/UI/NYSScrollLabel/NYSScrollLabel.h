//
//  NYSScrollLabel.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

#define NYSScrollLabelViewDidAppearNotification            @"NYSScrollLabelViewDidAppearNotification"

@interface NYSScrollLabel : UIView

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
