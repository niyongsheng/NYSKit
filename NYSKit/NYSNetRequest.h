//
//  NYSRequestManager.h
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

// 被踢下线
#define NNotificationOnKick                     @"KNotificationOnKick"
// 令牌失效
#define NNotificationTokenInvalidation          @"KNotificationTokenInvalidation"
// 网络状态
#define NNotificationNetworkChange              @"KNotificationNetworkChange"

typedef NS_ENUM(NSInteger, NYSNetRequestType) {
    GET = 0,
    POST,
    DELETE,
    PUT
};

typedef void(^NYSNetRequestSuccess)(id _Nullable response);
typedef void(^NYSNetRequestFailed)(NSError * _Nullable error);

@interface NYSNetRequest : NSObject

/// Form表单网络请求
+ (void)requestNetworkWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id _Nullable)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// Form表单网络请求
/// 不校验接口返回数据的合法性
+ (void)requestNoCheckNetworkWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id _Nullable)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// JSON传参网络请求
+ (void)jsonNetworkRequestWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id _Nullable)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// JSON传参网络请求
/// 不校验接口返回数据的合法性
+ (void)jsonNoCheckNetworkRequestWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id _Nullable)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// JSON传参网络请求
/// 自定义数据序列化方式responseSerializer
+ (void)jsonRequestWithType:(NYSNetRequestType)type
                        url:(NSString * _Nonnull)url
                 parameters:(id _Nullable)parameters
         responseSerializer:(id <AFURLResponseSerialization> _Nonnull)responseSerializer
                    isCheck:(BOOL)isCheck
                     remark:(NSString * _Nullable)remark
                    success:(NYSNetRequestSuccess _Nullable)success
                     failed:(NYSNetRequestFailed _Nullable)failed;

/// 文件上传
+ (void)uploadImagesWithType:(NYSNetRequestType)type
                         url:(NSString * _Nonnull)url
                  parameters:(id _Nullable)parameters
                        name:(NSString * _Nonnull)name
                       files:(NSArray * _Nonnull)files
                   fileNames:(NSArray<NSString *> * _Nullable)fileNames
                  imageScale:(CGFloat)imageScale
                   imageType:(NSString * _Nullable)imageType
                      remark:(NSString * _Nullable)remark
          responseSerializer:(id <AFURLResponseSerialization> _Nonnull)responseSerializer
                    progress:(nullable void (^)(NSProgress * _Nonnull))process
                     success:(NYSNetRequestSuccess _Nullable )success
                      failed:(NYSNetRequestFailed _Nullable )failed;

/// 阿里云OSS图片上传
+ (void)ossUploadImageWithuUrlStr:(NSString * _Nonnull)urlStr
                       parameters:(id _Nullable)parameters
                             name:(NSString * _Nonnull)name
                            image:(UIImage * _Nonnull)image
                        imageName:(NSString * _Nonnull)imageName
                       imageScale:(CGFloat)imageScale
                        imageType:(NSString * _Nullable)imageType
                           remark:(id _Nullable)remark
                         progress:(nullable void (^)(NSProgress * _Nullable))process
                          success:(NYSNetRequestSuccess _Nullable )success
                           failed:(NYSNetRequestFailed _Nullable )failed;

#pragma mark - Mock
/// Mock网络请求
/// - Parameters:
///   - type: 请求方式
///   - url: 路径：xxx.json || xx/xx/xxx.json
///   - parameters: 参数
///   - remark: 备注
///   - success: 读取成功回调
///   - failed: 读取失败回调
+ (void)mockRequestWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id _Nullable)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// JSON样式编码
/// - Parameter dict: 字典
+ (NSString * _Nonnull)jsonPrettyStringEncoded:(NSDictionary * _Nonnull)dict;

@end
