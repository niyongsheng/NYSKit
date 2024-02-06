//
//  NSString+NYS.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NYS)

/// 计算字符串高度
/// - Parameters:
///   - width: 宽度
///   - font: 字体
- (CGFloat)heightWithConstrainedWidth:(CGFloat)width font:(UIFont *)font;

/// 是否为空
/// - Parameter string: 字符串
+ (BOOL)isBlank:(NSString *)string;

/// 生成指定长度随机字符串
/// - Parameter length: 长度
+ (NSString *)randomStringWithLength:(NSUInteger)length;

/// 生成指定范围和长度的随机字符串
/// - Parameters:
///   - letters: 生成范围
///   - length: 长度
+ (NSString *)randomStringWithLetters:(NSString *)letters length:(NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
