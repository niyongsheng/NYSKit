//
//  UIControl+NYS.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (NYS)

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;
- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

@end
