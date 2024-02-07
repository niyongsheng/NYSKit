//
//  NYSPopView.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSPopView.h"
#import "NYSPopAnimationTool.h"

@interface NYSPopView()<CAAnimationDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,weak) UIView *contentView;
@property (nonatomic ,weak) UIView *onView;
@property (nonatomic ,assign) NYSPopViewDirection direct;
@property (nonatomic ,assign) BOOL animation;

@property (nonatomic ,strong) UIView *triangleView;
@property (nonatomic ,assign) CGFloat offset;
@property (nonatomic ,strong) UIResponder *backCtl;

@property (nonatomic ,strong) CABasicAnimation *showAnimation;
@property (nonatomic ,strong) CABasicAnimation *hidenAnimation;
@end

@implementation NYSPopView

static  NSInteger const NYSPopViewTag              = 364;
+ (instancetype)getCurrentNYSPopView {
    UIWindow *window = nil;
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        if (win.isKeyWindow) {
            window = win;
            break;
        }
    }
    NYSPopView *oldNYSPopView = (NYSPopView *)[window viewWithTag:NYSPopViewTag];
    return oldNYSPopView;
}

#pragma mark- popAnimation
+ (instancetype)popUpContentView:(UIView *)contentView
                        direct:(NYSPopViewDirection)direct
                        onView:(UIView *)onView {
    return [self popUpContentView:contentView direct:direct onView:onView offset:0 triangleView:nil animation:YES];
}

+ (instancetype)popUpContentView:(UIView *)contentView
                        direct:(NYSPopViewDirection)direct
                        onView:(UIView *)onView
                        offset:(CGFloat)offset
                  triangleView:(UIView *)triangleView
                     animation:(BOOL)animation {
    UIWindow *window = nil;
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        if (win.isKeyWindow) {
            window = win;
            break;
        }
    }
    NYSPopView *oldNYSPopView = [self getCurrentNYSPopView];
    NYSPopView *newNYSPopView = [[NYSPopView alloc] initWithFrame:window.bounds
                                                  direct:direct
                                                  onView:onView
                                             contentView:contentView
                                                  offSet:offset
                                            triangleView:triangleView
                                               animation:animation];
    [window addSubview:newNYSPopView];
    newNYSPopView.showAnimation = [NYSPopAnimationTool getShowPopAnimationWithType:direct contentView:contentView belowView:nil];
    newNYSPopView.hidenAnimation = [NYSPopAnimationTool getHidenPopAnimationWithType:direct contentView:contentView belowView:nil];
    
    [newNYSPopView setPopMenuSubViewFrame];
    [newNYSPopView animationPopContainerViewWithOldNYSPopView:oldNYSPopView];
    [newNYSPopView bringSubviewToFront:newNYSPopView.popContainerView];
    return newNYSPopView;
}


#pragma mark- slideAnimation
+ (instancetype)popSideContentView:(UIView *)contentView
                            direct:(NYSPopViewDirection)direction {
    CABasicAnimation *showAnimation = [NYSPopAnimationTool getShowPopAnimationWithType:direction contentView:contentView belowView:nil];
    CABasicAnimation *hidenAnimation = [NYSPopAnimationTool getHidenPopAnimationWithType:direction contentView:contentView belowView:nil];
    
    NYSPopView *NYSPopView =  [self popContentView:contentView showAnimation:showAnimation hidenAnimation:hidenAnimation];
    NYSPopView.popContainerView.center = [showAnimation.toValue CGPointValue];
    return NYSPopView;
}

+ (instancetype)popSideContentView:(UIView *)contentView
                         belowView:(UIView *)belowView {
    NYSPopViewDirection direction = NYSPopViewDirection_SlideBelowView;
    CABasicAnimation *showAnimation = [NYSPopAnimationTool getShowPopAnimationWithType:direction contentView:contentView belowView:belowView];
    CABasicAnimation *hidenAnimation = [NYSPopAnimationTool getHidenPopAnimationWithType:direction contentView:contentView belowView:belowView];
    CGRect frame = belowView.superview.bounds;
    frame.origin.y = CGRectGetMaxY(belowView.frame);
    frame.size.height -= CGRectGetMaxY(belowView.frame);
    
    NYSPopView *oldNYSPopView = (NYSPopView *)[belowView.superview viewWithTag:NYSPopViewTag];
    NYSPopView *newNYSPopView = [[NYSPopView alloc] initWithFrame:frame
                                                  direct:direction
                                                  onView:nil
                                             contentView:contentView
                                                  offSet:0
                                            triangleView:nil
                                               animation:YES];
    [belowView.superview insertSubview:newNYSPopView belowSubview:belowView];
    newNYSPopView.popContainerView.frame = contentView.frame;
    [newNYSPopView.popContainerView addSubview:contentView];
    newNYSPopView.clipsToBounds = YES;
    
    newNYSPopView.showAnimation = showAnimation;
    newNYSPopView.hidenAnimation = hidenAnimation;
    
    [newNYSPopView animationPopContainerViewWithOldNYSPopView:oldNYSPopView];
    newNYSPopView.popContainerView.center = [showAnimation.toValue CGPointValue];
    return newNYSPopView;
}

+ (instancetype)popContentView:(UIView *)contentView
                     showAnimation:(CABasicAnimation *)showAnimation
                    hidenAnimation:(CABasicAnimation *)hidenAnimation {
    UIWindow *window = nil;
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        if (win.isKeyWindow) {
            window = win;
            break;
        }
    }
    NYSPopView *oldNYSPopView = (NYSPopView *)[window viewWithTag:NYSPopViewTag];
    NYSPopView *newNYSPopView = [[NYSPopView alloc] initWithFrame:window.bounds
                                                  direct:NYSPopViewDirection_PopUpNone
                                                  onView:nil
                                             contentView:contentView
                                                  offSet:0
                                            triangleView:nil
                                               animation:YES];
    [window addSubview:newNYSPopView];
    newNYSPopView.popContainerView.frame = contentView.frame;
    [newNYSPopView.popContainerView addSubview:contentView];
    contentView.frame = newNYSPopView.popContainerView.bounds;

    
    newNYSPopView.showAnimation = showAnimation;
    newNYSPopView.hidenAnimation = hidenAnimation;

    [newNYSPopView animationPopContainerViewWithOldNYSPopView:oldNYSPopView];
    [newNYSPopView bringSubviewToFront:newNYSPopView.popContainerView];
    return newNYSPopView;
}


- (instancetype)initWithFrame:(CGRect)frame
                       direct:(NYSPopViewDirection)direct
                       onView:(UIView *)onView
                  contentView:(UIView *)contentView
                       offSet:(CGFloat)offset
                 triangleView:(UIView *)triangleView
                    animation:(BOOL)animation {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = NYSPopViewTag;
        self.direct = direct;
        self.contentView = contentView;
        self.clickOutHidden = YES;
        self.onView = onView;
        self.offset = offset;
        self.triangleView = triangleView ? triangleView : self.defaultTriangleView;
        self.animation = animation;
        self.keyBoardMargin = 10;

        UIControl *backCtl = [[UIControl alloc] initWithFrame:self.bounds];
        [self addSubview:backCtl];
        self.backCtl = backCtl;
        [backCtl addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addKeyboardNotification];
    }
    return self;
}

- (void)setPopMenuSubViewFrame {
    CGRect triangleFrame = self.triangleView.bounds;
    CGRect contentFrame = self.contentView.bounds;
    CGRect popContentFrame = CGRectZero;
    CGRect onViewFrame = [self.onView convertRect:self.onView.bounds toView:nil];
    
    CGPoint anchorPoint = CGPointMake(.5, .5);
    UIWindow *window = nil;
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        if (win.isKeyWindow) {
            window = win;
            break;
        }
    }
    switch (self.direct) {
        case NYSPopViewDirection_PopUpBottom:
            //1、计算在window上的位置
            //1.2、计算指示器在window的位置
            triangleFrame.origin.y = CGRectGetMaxY(onViewFrame);
            triangleFrame.origin.x = onViewFrame.origin.x + onViewFrame.size.width/2 - triangleFrame.size.width/2;
            
            //1.2、计算内容在window的位置
            contentFrame.origin.y = CGRectGetMaxY(triangleFrame);
            contentFrame.origin.x = onViewFrame.origin.x + onViewFrame.size.width/2 - contentFrame.size.width/2 + self.offset;
            if (contentFrame.origin.x<NYSPopViewInsert) {
                contentFrame.origin.x = NYSPopViewInsert;
            }
            if (CGRectGetMaxX(contentFrame)>window.bounds.size.width) {
                contentFrame.origin.x = window.bounds.size.width - NYSPopViewInsert - contentFrame.size.width;
            }
            
            popContentFrame = CGRectUnion(triangleFrame, contentFrame);
            self.popContainerView.frame = popContentFrame;
            
            //2、计算指示器实际的位置
            self.triangleView.frame = triangleFrame;
            [window addSubview:self.triangleView];
            self.triangleView.frame = [self.triangleView convertRect:self.triangleView.bounds toView:self.popContainerView];
            [self.popContainerView addSubview:self.triangleView];
            
            //3、计算内容实际的位置
            self.contentView.frame = contentFrame;
            [window addSubview:self.contentView];
            self.contentView.frame = [self.contentView convertRect:self.contentView.bounds toView:self.popContainerView];
            [self.popContainerView addSubview:self.contentView];
            
            //4、计算锚点
            anchorPoint.y = 0;
            anchorPoint.x = (self.triangleView.frame.origin.x + self.triangleView.frame.size.width/2)/popContentFrame.size.width;
            self.popContainerView.layer.anchorPoint = anchorPoint;
            self.popContainerView.layer.position = CGPointMake(onViewFrame.origin.x + onViewFrame.size.width/2, CGRectGetMaxY(onViewFrame));
            break;
        case NYSPopViewDirection_PopUpTop:
            //1、计算在window上的位置
            //1.2、计算指示器在window的位置
            triangleFrame.origin.y = onViewFrame.origin.y;
            triangleFrame.origin.x = onViewFrame.origin.x + onViewFrame.size.width/2 - triangleFrame.size.width/2;
            
            //1.2、计算内容在window的位置
            contentFrame.origin.y = triangleFrame.origin.y - contentFrame.size.height;
            contentFrame.origin.x = onViewFrame.origin.x + onViewFrame.size.width/2 - contentFrame.size.width/2 + self.offset;
            if (contentFrame.origin.x<NYSPopViewInsert) {
                contentFrame.origin.x = NYSPopViewInsert;
            }
            if (CGRectGetMaxX(contentFrame)>window.bounds.size.width) {
                contentFrame.origin.x = window.bounds.size.width - NYSPopViewInsert - contentFrame.size.width;
            }
            
            popContentFrame = CGRectUnion(triangleFrame, contentFrame);
            self.popContainerView.frame = popContentFrame;
            
            //2、计算指示器实际的位置
            self.triangleView.frame = triangleFrame;
            [window addSubview:self.triangleView];
            self.triangleView.frame = [self.triangleView convertRect:self.triangleView.bounds toView:self.popContainerView];
            [self.popContainerView addSubview:self.triangleView];
            
            
            //3、计算内容实际的位置
            self.contentView.frame = contentFrame;
            [window addSubview:self.contentView];
            self.contentView.frame = [self.contentView convertRect:self.contentView.bounds toView:self.popContainerView];
            [self.popContainerView addSubview:self.contentView];
            
            //4、计算锚点
            anchorPoint.y = 1;
            anchorPoint.x = (self.triangleView.frame.origin.x + self.triangleView.frame.size.width/2)/popContentFrame.size.width;
            self.popContainerView.layer.anchorPoint = anchorPoint;
            self.popContainerView.layer.position = CGPointMake(onViewFrame.origin.x + onViewFrame.size.width/2, onViewFrame.origin.y);
            
            break;
        case NYSPopViewDirection_PopUpRight:
            
            //1、计算在window上的位置
            //1.2、计算指示器在window的位置
            triangleFrame.origin.y = onViewFrame.origin.y + onViewFrame.size.height/2- triangleFrame.size.height/2;
            triangleFrame.origin.x = CGRectGetMaxX(onViewFrame);
            
            //1.2、计算内容在window的位置
            contentFrame.origin.y = triangleFrame.origin.y + triangleFrame.size.width/2- contentFrame.size.height/2 + self.offset;
            contentFrame.origin.x = CGRectGetMaxX(triangleFrame);
            
            //1、3备注：适配整个屏幕
            if (contentFrame.origin.y<NYSPopViewInsert) {
                contentFrame.origin.y = NYSPopViewInsert;
            }
            if (CGRectGetMaxY(contentFrame)>window.bounds.size.height) {
                contentFrame.origin.y = window.bounds.size.height - NYSPopViewInsert - contentFrame.size.height;
            }
            
            popContentFrame = CGRectUnion(triangleFrame, contentFrame);
            self.popContainerView.frame = popContentFrame;
            
            //2、计算指示器实际的位置
            self.triangleView.frame = triangleFrame;
            [window addSubview:self.triangleView];
            self.triangleView.frame = [self.triangleView convertRect:self.triangleView.bounds toView:self.popContainerView];
            [self.popContainerView addSubview:self.triangleView];
            
            
            //3、计算内容实际的位置
            self.contentView.frame = contentFrame;
            [window addSubview:self.contentView];
            self.contentView.frame = [self.contentView convertRect:self.contentView.bounds toView:self.popContainerView];
            [self.popContainerView addSubview:self.contentView];
            
            //4、计算锚点
            anchorPoint.y = (self.triangleView.frame.origin.y + self.triangleView.frame.size.height/2)/popContentFrame.size.height;
            anchorPoint.x = 0;
            self.popContainerView.layer.anchorPoint = anchorPoint;
            self.popContainerView.layer.position = CGPointMake(CGRectGetMaxX(onViewFrame), onViewFrame.origin.y + onViewFrame.size.height/2);
            
            //5、超出屏幕外
            if (CGRectGetMaxX(contentFrame)>window.bounds.size.width) {
                CGPoint popContentPosition = self.popContainerView.layer.position;
                popContentPosition.x = window.bounds.size.width - popContentFrame.size.width - NYSPopViewInsert;
                self.popContainerView.layer.position = popContentPosition;
            }
            break;
            
        case NYSPopViewDirection_PopUpLeft:
            
            //1、计算在window上的位置
            //1.2、计算指示器在window的位置
            triangleFrame.origin.y = onViewFrame.origin.y + onViewFrame.size.height/2- triangleFrame.size.height/2;
            triangleFrame.origin.x = onViewFrame.origin.x;
            
            //1.2、计算内容在window的位置
            contentFrame.origin.y = onViewFrame.origin.y + onViewFrame.size.height/2- contentFrame.size.height/2 + self.offset;
            contentFrame.origin.x = triangleFrame.origin.x - contentFrame.size.width;
            
            //1、3备注：适配整个屏幕
            if (contentFrame.origin.y<NYSPopViewInsert) {
                contentFrame.origin.y = NYSPopViewInsert;
            }
            if (CGRectGetMaxY(contentFrame)>window.bounds.size.height) {
                contentFrame.origin.x = window.bounds.size.height - NYSPopViewInsert - contentFrame.size.height;
            }
            
            popContentFrame = CGRectUnion(triangleFrame, contentFrame);
            self.popContainerView.frame = popContentFrame;
            
            //2、计算指示器实际的位置
            self.triangleView.frame = triangleFrame;
            [window addSubview:self.triangleView];
            self.triangleView.frame = [self.triangleView convertRect:self.triangleView.bounds toView:self.popContainerView];
            [self.popContainerView addSubview:self.triangleView];
            
            
            //3、计算内容实际的位置
            self.contentView.frame = contentFrame;
            [window addSubview:self.contentView];
            self.contentView.frame = [self.contentView convertRect:self.contentView.bounds toView:self.popContainerView];
            [self.popContainerView addSubview:self.contentView];
            
            //4、计算锚点
            anchorPoint.y = (self.triangleView.frame.origin.y + self.triangleView.frame.size.height/2)/popContentFrame.size.height;
            anchorPoint.x = 1;
            self.popContainerView.layer.anchorPoint = anchorPoint;
            self.popContainerView.layer.position = CGPointMake(onViewFrame.origin.x, onViewFrame.origin.y + onViewFrame.size.height/2);
            break;
        case NYSPopViewDirection_PopUpNone:
            self.contentView.frame = self.contentView.bounds;
            self.popContainerView.frame = self.contentView.bounds;
            self.popContainerView.center = window.center;
            [self.popContainerView addSubview:self.contentView];
            break;
        default:
            break;
    }
}

- (void)backClick {
    if (!keyboardShow) {
        if (self.clickOutHidden) {
            [NYSPopView hidenPopView];
        }
    }
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            [window endEditing:YES];
            break;
        }
    }
}

//处理响应者链
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *responseView = nil;
    CGRect iframe = [self.responseOnView convertRect:self.responseOnView.bounds toView:nil];
    if (CGRectContainsPoint(iframe, point)) {
        for (UIView *view in self.responseOnView.subviews) {
            CGRect subIframe = [view convertRect:view.bounds toView:nil];
            if (CGRectContainsPoint(subIframe, point)) {
                [NYSPopView hidenPopView];
                responseView = view;
            }
        }
        if (responseView == nil) {
            responseView = self.responseOnView;
        }
    }
    responseView = [super hitTest:point withEvent:event];
    //不是两个输入框切换的时候
    if (![responseView isKindOfClass:[UITextView class]] && ![responseView isKindOfClass:[UITextField class]] && responseView != self.backCtl) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.isKeyWindow) {
                [window endEditing:YES];
                break;
            }
        }
    }
    return responseView;
}



#pragma mark - animation
- (void)animationPopContainerViewWithOldNYSPopView:(NYSPopView *)oldNYSPopView {
    if (oldNYSPopView) {
        if (oldNYSPopView.willRemovedFromeSuperView) {
            oldNYSPopView.willRemovedFromeSuperView();
        }
        [oldNYSPopView removeFromSuperview];
    }
    UIColor *color = self.backgroundColor;
    [self.popContainerView.layer addAnimation:self.showAnimation forKey:nil];
    [self animationBackGroundColor:[UIColor clearColor] toColor:color];
}

- (void)animationBackGroundColor:(UIColor*)fromeColor toColor:(UIColor *)toColor {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.fromValue = (id)fromeColor.CGColor;
    animation.toValue = (id)toColor.CGColor;
    animation.duration = animationDuration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:@"backgroundColor"];
}

+ (void)hidenPopView {
    if (keyboardShow) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.isKeyWindow) {
                [window endEditing:YES];
                break;
            }
        }
    } else {
        UIWindow *window = nil;
        for (UIWindow *win in [UIApplication sharedApplication].windows) {
            if (win.isKeyWindow) {
                window = win;
                break;
            }
        }
        NYSPopView *popView = (NYSPopView *)[window viewWithTag:NYSPopViewTag];
        if (popView && ![popView.popContainerView.layer animationForKey:@"hiddenAnimation"]) {
            if (popView.willRemovedFromeSuperView) {
                popView.willRemovedFromeSuperView();
            }
            if (popView.animation && popView.hidenAnimation) {
                popView.hidenAnimation.removedOnCompletion = NO;
                [popView.popContainerView.layer addAnimation:popView.hidenAnimation forKey:@"hiddenAnimation"];
                [popView animationBackGroundColor:popView.backgroundColor toColor:[UIColor clearColor]];
    
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popView.hidenAnimation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [popView removeFromSuperview];
                });
            }else{
                [popView removeFromSuperview];
            }
        }
    }
}

- (void)removeFromSuperview {
    if (self.didRemovedFromeSuperView) {
        self.didRemovedFromeSuperView();
    }
    [super removeFromSuperview];
}



#pragma mark-处理键盘
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static BOOL keyboardShow = NO;
static CGRect NYSPopViewOriginRect;
- (void)keyboardWillShow:(NSNotification *)notification {
    if (CGRectEqualToRect(NYSPopViewOriginRect, CGRectZero)) {
        NYSPopViewOriginRect = self.popContainerView.frame;
    }
    keyboardShow = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标;
    CGFloat animationDuration = [[userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    UIView *responsInputView = [self responsInputViewOnView:self.popContainerView];
    if (responsInputView) {
        UIWindow *window = nil;
        for (UIWindow *win in [UIApplication sharedApplication].windows) {
            if (win.isKeyWindow) {
                window = win;
                break;
            }
        }
        CGRect inputViewFrame = [responsInputView convertRect:responsInputView.bounds toView:window];
        if (CGRectGetMaxY(inputViewFrame)+self.keyBoardMargin>=keyBoardEndY) {
            [UIView animateWithDuration:animationDuration animations:^{
                CGRect _frame = self.popContainerView.frame;
                _frame.origin.y -= CGRectGetMaxY(inputViewFrame)+self.keyBoardMargin-keyBoardEndY;
                self.popContainerView.frame = _frame;
            }completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!CGRectEqualToRect(NYSPopViewOriginRect, CGRectZero)) {
        NSDictionary *userInfo = [notification userInfo];
        CGFloat animationDuration = [[userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
        [UIView animateWithDuration:animationDuration animations:^{
            self.popContainerView.frame = NYSPopViewOriginRect;
        }];
    }
    NYSPopViewOriginRect = CGRectZero;
    keyboardShow = NO;
}

//找到输入框
- (UIView *)responsInputViewOnView:(UIView *)onView {
    for (UIView *view in onView.subviews) {
        if (([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) && view.isFirstResponder) {
            return view;
        }else if(view.subviews.count>0){
            UIView *v = [self responsInputViewOnView:view];
            if (v != nil) {
                return v;
            }
        }
    }
    return nil;
}


#pragma mark-lazy
- (UIView *)defaultTriangleView {
    CGPoint point1 = CGPointZero;
    CGPoint point2 = CGPointZero;
    CGPoint point3 = CGPointZero;
    CGRect triangleFrame = CGRectZero;
    switch (self.direct) {
        case NYSPopViewDirection_PopUpLeft:
            point1 = CGPointMake(10, 10);
            point2 = CGPointMake(0, 0);
            point3 = CGPointMake(0, 20);
            triangleFrame.size = CGSizeMake(10, 20);
            break;
        case NYSPopViewDirection_PopUpRight:
            point1 = CGPointMake(0, 10);
            point2 = CGPointMake(10, 20);
            point3 = CGPointMake(10, 0);
            triangleFrame.size = CGSizeMake(10, 20);
            break;
        case NYSPopViewDirection_PopUpBottom:
            point1 = CGPointMake(10, 0);
            point2 = CGPointMake(20, 10);
            point3 = CGPointMake(0, 10);
            triangleFrame.size = CGSizeMake(20, 10);
            break;
        case NYSPopViewDirection_PopUpTop:
            point1 = CGPointMake(0, 0);
            point2 = CGPointMake(20, 0);
            point3 = CGPointMake(10, 10);
            triangleFrame.size = CGSizeMake(20, 10);
            break;
        default:
            break;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path closePath];
    
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    triangleLayer.fillColor = self.contentView.backgroundColor.CGColor;
    triangleLayer.path = path.CGPath;
    
    UIView *defaultTriangleView = [[UIView alloc] initWithFrame:triangleFrame];
    [defaultTriangleView.layer addSublayer:triangleLayer];
    return defaultTriangleView;
}

- (UIView *)popContainerView {
    if (_popContainerView == nil) {
        _popContainerView = [[UIView alloc] init];
        [self addSubview:_popContainerView];
    }
    return _popContainerView;
}
@end

