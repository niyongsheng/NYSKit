//
//  NYSKitManager.m
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSKitManager.h"

@implementation NYSKitManager

+ (NYSKitManager *)sharedNYSKitManager {
    static NYSKitManager *sharedNYSKitManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNYSKitManager = [[self alloc] init];
    });
    return sharedNYSKitManager;
}

- (NSString *)normalCode {
    if (!_normalCode) {
        _normalCode = @"200,0";
    }
    return _normalCode;
}

- (NSString *)tokenInvalidCode {
    if (!_tokenInvalidCode) {
        _tokenInvalidCode = @"403";
    }
    return _tokenInvalidCode;
}

- (NSString *)kickedCode {
    if (!_kickedCode) {
        _kickedCode = @"405";
    }
    return _kickedCode;
}

- (NSString *)msgKey {
    if (!_msgKey) {
        _msgKey = @"msg,message";
    }
    return _msgKey;
}

@end
