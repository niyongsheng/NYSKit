//
//  UIControl+NYS.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "UIControl+NYS.h"
#import <objc/runtime.h>

@implementation UIControl (NYS)

static const char *UIControlBlocksKey = "UIControlBlocksKey";

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, UIControlBlocksKey);
    if (!blocks) {
        blocks = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UIControlBlocksKey, blocks, OBJC_ASSOCIATION_RETAIN);
    }
    
    NSMutableArray *eventBlocks = blocks[@(controlEvents)];
    if (!eventBlocks) {
        eventBlocks = [NSMutableArray array];
        blocks[@(controlEvents)] = eventBlocks;
    }
    
    [eventBlocks addObject:block];
    [self addTarget:self action:@selector(handleControlEvent:) forControlEvents:controlEvents];
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, UIControlBlocksKey);
    if (blocks) {
        [blocks removeObjectForKey:@(controlEvents)];
    }
}

- (void)handleControlEvent:(UIControl *)control {
    UIControlEvents controlEvents = control.allControlEvents;
    NSMutableDictionary *blocks = objc_getAssociatedObject(control, UIControlBlocksKey);
    NSMutableArray *eventBlocks = blocks[@(controlEvents)];
    
    for (void (^block)(id sender) in eventBlocks) {
        block(control);
    }
}

@end
