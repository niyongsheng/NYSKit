//
//  NYSPopAnimationTool.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYSPopView.h"

@interface NYSPopAnimationTool : NSObject
+ (CABasicAnimation *)getShowPopAnimationWithType:(NYSPopViewDirection)popDirecton contentView:(UIView *)contentView belowView:(UIView *)belowView;
+ (CABasicAnimation *)getHidenPopAnimationWithType:(NYSPopViewDirection)popDirecton contentView:(UIView *)contentView belowView:(UIView *)belowView;
@end
