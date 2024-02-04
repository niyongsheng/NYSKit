//
//  NYSLoadingButton.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

@import UIKit;

typedef enum : NSUInteger {
    NONE = 0,
    TOP_LINE = 1,
    INDICATOR = 2,
    BACKGROUND_HIGHLIGHTER = 3,
    CIRCLE_AND_TICK = 4,
    ALL = 5
} LoadingType; 

IB_DESIGNABLE
@interface NYSLoadingButton : UIButton

/// BACKGROUND_HIGHLIGHTER | CIRCLE_AND_TICK 下有效
@property (copy) IBInspectable UIColor *loadingColor;
@property (copy) IBInspectable UIColor *filledBackgroundColor;
@property (assign) LoadingType animationType;

/// start loading
- (void)startLoading:(LoadingType)loadingType;
///stop loading
- (void)endAndDeleteLoading;
/// update filling background - percent like 1,20...100
- (void)fillTheButtonWith:(CGFloat)percent;
/// update circle mode stroke - percent like 1,20...100
- (void)fillTheCircleStrokeLoadingWith:(CGFloat)percent;
@end





