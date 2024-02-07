//
//  UITextField+NYS.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UITextField (NYS)

/// 最大可输入位数
@property (assign, nonatomic) IBInspectable NSInteger maxLength;

@end

