//
//  NSError+NYS.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NSError+NYS.h"

NSString *const NSNYSErrorDomain = @"NSNYSErrorDomain";

@implementation NSError (NYS)

+ (NSError*)errorCode:(NSNYSErrorCode)code{
    return [self errorCode:code userInfo:nil];
}

+ (NSError*)errorCode:(NSNYSErrorCode)code userInfo:(nullable NSDictionary*)userInfo{
    if (userInfo) {
        return [NSError errorWithDomain:NSNYSErrorDomain code:code userInfo:userInfo];
    }else{
        return [NSError errorWithDomain:NSNYSErrorDomain code:code userInfo:
                @{
                    NSLocalizedDescriptionKey:@"Unknow Error",
                    NSLocalizedFailureReasonErrorKey:@"no reason",
                    NSLocalizedRecoverySuggestionErrorKey:@"Retry",
                    @"NSCustomInfoKey": @"",
                }];
    }
}

+ (NSError*)errorCode:(NSNYSErrorCode)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion {
    return [NSError errorWithDomain:NSNYSErrorDomain code:code userInfo:
            @{
                NSLocalizedDescriptionKey:description,
                NSLocalizedFailureReasonErrorKey:reason,
                NSLocalizedRecoverySuggestionErrorKey:suggestion
            }];
}

+ (NSError*)errorCode:(NSNYSErrorCode)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion placeholderImg:(id)image {
    return [NSError errorWithDomain:NSNYSErrorDomain code:code userInfo:
            @{
                NSLocalizedDescriptionKey:description,
                NSLocalizedFailureReasonErrorKey:reason,
                NSLocalizedRecoverySuggestionErrorKey:suggestion,
                @"NSLocalizedPlaceholderImage": image
            }];
}

@end
