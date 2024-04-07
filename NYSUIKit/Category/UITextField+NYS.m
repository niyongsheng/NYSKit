//
//  UITextField+NYS.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "UITextField+NYS.h"
#import <objc/runtime.h>

static NSString * const NYSMaxLengthKey = @"NYSMaxLengthKey";

@implementation UITextField (NYS)

- (void)setMaxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, &NYSMaxLengthKey, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    
    [self addTarget:self action:@selector(NYSTextFieldTextChanged:)
   forControlEvents:UIControlEventEditingChanged];
}

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, &NYSMaxLengthKey) integerValue];
}

- (void)NYSTextFieldTextChanged:(UITextField *)textField {
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:textField.text.length -1];
    }
}

@end
