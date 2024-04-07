//
//  NYSKitManager.h
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYSKitManager : NSObject

+ (NYSKitManager *_Nonnull)sharedNYSKitManager;

#pragma mark - 网络请求参数配置
/// 请求地址
@property (nonatomic, strong) NSString * _Nonnull host;
/// token令牌
@property (nonatomic, strong) NSString * _Nullable token;
/// 正常返回代码（多个值以','分割）
@property (nonatomic, strong) NSString * _Nonnull normalCode;
/// 统一的数据Key（不设置返回所有字段）
@property (nonatomic, strong) NSString * _Nonnull dataKey;
/// 错误信息Key
@property (nonatomic, strong) NSString * _Nonnull msgKey;
/// 是否Toast错误信息 default:NO
@property (nonatomic, assign) BOOL       isAlwaysShowErrorMsg;

/// token令牌失效错误码
@property (nonatomic, strong) NSString * _Nonnull tokenInvalidCode;
/// token令牌失效错误信息
@property (nonatomic, strong) NSString * _Nonnull tokenInvalidMessage;
/// 被踢/其他设备登录-错误码
@property (nonatomic, strong) NSString * _Nonnull kickedCode;


#pragma mark - Other

@end
