//
//  NYSRequestManager.h
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

// 被踢下线
#define NNotificationOnKick                     @"KNotificationOnKick"
// 令牌失效
#define NNotificationTokenInvalidation          @"KNotificationTokenInvalidation"
// 网络状态
#define NNotificationNetworkChange              @"KNotificationNetworkChange"

typedef enum : NSUInteger {
    GET = 0,
    POST,
    DELETE,
    PUT
} NYSNetRequestType;

typedef void(^NYSNetRequestSuccess)(NSDictionary * _Nullable response);
typedef void(^NYSNetRequestFailed)(NSError * _Nullable error);

@interface NYSNetRequest : NSObject

/// Form表单网络请求
+ (void)requestNetworkWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id _Nullable)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// JSON传参网络请求
+ (void)jsonNetworkRequestWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id _Nullable)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// JSON传参网络请求(不统一检查接口返回数据的合法性)
+ (void)jsonNoCheckNetworkRequestWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id _Nullable)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// 文件上传
+ (void)uploadImagesWithType:(NYSNetRequestType)type
                       url:(NSString * _Nonnull)url
                  parameters:(id _Nullable)parameters
                      name:(NSString * _Nonnull)name
                       files:(NSArray * _Nonnull)files
                 fileNames:(NSArray<NSString *> *_Nullable)fileNames
                imageScale:(CGFloat)imageScale
                 imageType:(NSString * _Nullable)imageType
                    remark:(id _Nullable)remark
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
///   - parameters: 参数：文件名xxx.json || 路径xx/xx/xxx.txt
///   - isCheck: 是否校验
///   - remark: 备注
///   - success: 读取成功回调
///   - failed: 读取失败回调
+ (void)mockRequestWithParameters:(NSString * _Nonnull)parameters isCheck:(BOOL)isCheck remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

@end
