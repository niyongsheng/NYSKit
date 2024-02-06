//
//  UIColor+NYS.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "UIColor+NYS.h"

@implementation UIColor (NYS)

- (instancetype)initWithHexString:(NSString *)hexString {
    return [self initWithHexString:hexString alpha:1];
}

- (instancetype)initWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *formattedHex = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    formattedHex = [formattedHex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSScanner *scanner = [NSScanner scannerWithString:formattedHex];
    unsigned long long rgbValue = 0;
    [scanner scanHexLongLong:&rgbValue];
    
    CGFloat red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((rgbValue & 0x00FF00) >> 8) / 255.0;
    CGFloat blue = (rgbValue & 0x0000FF) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (instancetype)initWithRandomColor {
    CGFloat red = arc4random() % 256 / 255.0;
    CGFloat green = arc4random() % 256 / 255.0;
    CGFloat blue = arc4random() % 256 / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (NSString *)transformHexString {
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int intRed = red * 255.0;
    int intGreen = green * 255.0;
    int intBlue = blue * 255.0;
    
    return [NSString stringWithFormat:@"#%02X%02X%02X", intRed, intGreen, intBlue];
}

+ (CAGradientLayer *)gradientFromColor:(UIColor *)startColor toColor:(UIColor *)endColor direction:(GradientDirection)direction {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    
    switch (direction) {
        case GradientDirectionHorizontal:
            gradientLayer.startPoint = CGPointMake(0, 0.5);
            gradientLayer.endPoint = CGPointMake(1, 0.5);
            break;
        case GradientDirectionVertical:
            gradientLayer.startPoint = CGPointMake(0.5, 0);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
            break;
    }
    
    return gradientLayer;
}

@end
