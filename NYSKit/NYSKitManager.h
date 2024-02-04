//
//  NYSKitManager.h
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYSKitManager : NSObject

+ (NYSKitManager *_Nonnull)sharedNYSKitManager;

#pragma mark - 网络请求配置
/// 请求地址
@property (nonatomic, strong) NSString * _Nonnull host;
/// 授权令牌
@property (nonatomic, strong) NSString * _Nullable token;
/// 正常返回代码
@property (nonatomic, strong) NSString * _Nonnull normalCode;
/// 令牌失效错误码
@property (nonatomic, strong) NSString * _Nonnull tokenInvalidCode;
@property (nonatomic, strong) NSString * _Nonnull tokenInvalidMessage;
/// 被踢/其他设备登录-错误码
@property (nonatomic, strong) NSString * _Nonnull kickedCode;
/// 错误信息Key
@property (nonatomic, strong) NSString * _Nonnull msgKey;
/// 总是Toast错误信息
@property (nonatomic, assign) BOOL       isAlwaysShowErrorMsg;

#pragma mark - Other

@end
