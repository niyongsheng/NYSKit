//
//  NSString+NYS.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NSString+NYS.h"

@implementation NSString (NYS)

+ (BOOL)isBlank:(NSString *)string {
    if (!string) {
        return YES;
    }
    
    return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0;
}

- (CGFloat)heightWithConstrainedWidth:(CGFloat)width font:(UIFont *)font {
    CGSize constraintRect = CGSizeMake(width, CGFLOAT_MAX);
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    CGRect boundingBox = [self boundingRectWithSize:constraintRect
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil];
    
    return boundingBox.size.height;
}

+ (NSString *)randomStringWithLength:(NSUInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return [NSString randomStringWithLetters:letters length:length];
}

+ (NSString *)randomStringWithLetters:(NSString *)letters length:(NSUInteger)length {
    if (letters.length == 0 || length == 0) {
        return @"";
    }
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (NSUInteger i = 0; i < length; i++) {
        NSUInteger randomIndex = arc4random_uniform((uint32_t)letters.length);
        unichar randomChar = [letters characterAtIndex:randomIndex];
        [randomString appendFormat:@"%C", randomChar];
    }
    
    return randomString;
}

@end
