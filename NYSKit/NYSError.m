//
//  NYSError.m
//  NYSKit
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSError.h"

@implementation NYSError

- (instancetype)initWithDomain:(NSErrorDomain)domain code:(NSInteger)code {

    self = [super initWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey: @"An NYSkit error occurred."}];
    if (self) {
        
    }
    return self;
}

@end
