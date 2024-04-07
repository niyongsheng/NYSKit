//
//  UIButton+NYS.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "UIButton+NYS.h"
#import <objc/runtime.h>

static char const * const activityIndicatorKey = "activityIndicator";

@implementation UIButton (NYS)

static char edgeKey;

- (NSString *)enlargeEdge {
    return objc_getAssociatedObject(self, &edgeKey);
}

- (void)enlargeTouchEdge:(UIEdgeInsets)edge {
    NSString *edgeStr = NSStringFromUIEdgeInsets(edge);
    objc_setAssociatedObject(self, &edgeKey, edgeStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets changeInsets = UIEdgeInsetsFromString([self enlargeEdge]);
    CGFloat x = self.bounds.origin.x + changeInsets.left;
    CGFloat y = self.bounds.origin.y + changeInsets.top;
    CGFloat width = self.bounds.size.width - changeInsets.left - changeInsets.right;
    CGFloat height = self.bounds.size.height - changeInsets.top - changeInsets.bottom;
    CGRect rect = CGRectMake(x, y, width, height);
    
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA = class_getInstanceMethod(self, selA);
        Method methodB = class_getInstanceMethod(self, selB);
        
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        } else {
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.isIgnore) {
        [self mySendAction:action to:target forEvent:event];
        return;
    }
    
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        self.timeInterval = self.timeInterval == 0 ? defaultInterval : self.timeInterval;
        
        if (self.isIgnoreEvent) {
            return;
        } else if (self.timeInterval > 0) {
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
    }
    
    self.isIgnoreEvent = YES;
    [self mySendAction:action to:target forEvent:event];
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsIgnore:(BOOL)isIgnore {
    objc_setAssociatedObject(self, @selector(isIgnore), @(isIgnore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnore {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)resetState {
    [self setIsIgnoreEvent:NO];
}

#pragma mark - ActivityIndicator functions
- (void)startLoading {
    UIActivityIndicatorView *activityIndicator = [self activityIndicator];
    
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        // 指示器与按钮title之间的间距
        CGFloat indicatorMargin = 5.0;
        CGFloat indicatorX = CGRectGetMaxX(self.titleLabel.frame) + indicatorMargin;
        CGFloat indicatorY = CGRectGetMidY(self.titleLabel.frame) - activityIndicator.frame.size.height / 2;
        CGRect indicatorFrame = CGRectMake(indicatorX, indicatorY, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
        activityIndicator.frame = indicatorFrame;
        
        activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:activityIndicator];
        [self setActivityIndicator:activityIndicator];
    }
    
    [activityIndicator startAnimating];
    self.enabled = NO;
}

- (void)stopLoading {
    UIActivityIndicatorView *activityIndicator = [self activityIndicator];
    
    if (activityIndicator) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [self setActivityIndicator:nil];
    }
    
    self.enabled = YES;
}

- (UIActivityIndicatorView *)activityIndicator {
    return objc_getAssociatedObject(self, activityIndicatorKey);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, activityIndicatorKey, activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
