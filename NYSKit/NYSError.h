//
//  NYSError.h
//  NYSKit
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSError : NSError

- (instancetype)initWithDomain:(NSErrorDomain)domain code:(NSInteger)code;

@end

NS_ASSUME_NONNULL_END
