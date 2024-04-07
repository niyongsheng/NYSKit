//
//  NYSRequestManager.m
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSNetRequest.h"
#import "NYSKitPublicHeader.h"
#import "NYSTools.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define isShowTimes NO
#define TimeoutInterval 15
#define ShowDelayLoading 1.5f
#define MockDelayLoading 0.5f

@interface NYSNetRequest ()

@end

@implementation NYSNetRequest

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"image/jpg"];
        [contentTypes addObject:@"text/plain"];
        [contentTypes addObject:@"image/jpeg"];
        [contentTypes addObject:@"application/json"];
        [contentTypes addObject:@"application/octet-stream"];
        manager.responseSerializer.acceptableContentTypes = contentTypes;
        [manager.requestSerializer setTimeoutInterval:TimeoutInterval];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationNetworkChange object:@(status)];
        }];
    });
    return manager;
}

+ (NSDictionary *)headers {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    NSString *uuid = [NYSTools getDeviceIdentifier];
    [headerDic setValue:uuid forKey:@"x-device-imei"];
    NSString *language = [[NSBundle mainBundle] preferredLocalizations].firstObject; // @"zh_CN"
    [headerDic setValue:language forKey:@"Accept-hips-Language"];
    
    NSString *tokenStr = [[NYSKitManager sharedNYSKitManager] token];
    if (![NYSTools isBlankString:tokenStr]) {
        [headerDic setValue:[NSString stringWithFormat:@"Bearer %@", tokenStr] forKey:@"Authorization"];
    }
    [headerDic setValue:[[UIDevice currentDevice] systemName] forKey:@"deviceSystemName"];
    [headerDic setValue:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
    [headerDic setValue:[[UIDevice currentDevice] localizedModel] forKey:@"localizedModel"];
    [headerDic setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    
    return headerDic;
}

#pragma mark - Form表单网络请求
+ (void)requestNetworkWithType:(NYSNetRequestType)type
                           url:(NSString * _Nonnull)url
                    parameters:(id)parameters
                        remark:(NSString *)remark
                       success:(NYSNetRequestSuccess _Nullable )success
                        failed:(NYSNetRequestFailed _Nullable )failed {
    [self requestNetworkWithType:type url:url parameters:parameters isCheck:YES remark:remark success:success failed:failed];
}

+ (void)requestNoCheckNetworkWithType:(NYSNetRequestType)type
                                  url:(NSString * _Nonnull)url
                           parameters:(id)parameters
                               remark:(NSString *)remark
                              success:(NYSNetRequestSuccess _Nullable )success
                               failed:(NYSNetRequestFailed _Nullable )failed {
    [self requestNetworkWithType:type url:url parameters:parameters isCheck:NO remark:remark success:success failed:failed];
}

+ (void)requestNetworkWithType:(NYSNetRequestType)type
                           url:(NSString * _Nonnull)url
                    parameters:(id)parameters
                       isCheck:(BOOL)isCheck
                        remark:(NSString *)remark
                       success:(NYSNetRequestSuccess _Nullable )success
                        failed:(NYSNetRequestFailed _Nullable )failed {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    AFHTTPResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    /**
     NSMutableIndexSet *acceptableStatusCodes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 2)];
     [acceptableStatusCodes addIndex:401]; // 添加需要认为是成功的状态码，即使状态码出错也继续解析数据
     serializer.acceptableStatusCodes = acceptableStatusCodes;
     */
    [self sharedManager].responseSerializer = serializer;
    
    NSDictionary *header = [self headers];
    NSString *urlStr = [[[NYSKitManager sharedNYSKitManager] host] stringByAppendingString:url];
    if ([url containsString:@"http"]) {
        urlStr = url;
    }
    switch (type) {
            
        case GET: {
            [[self sharedManager] GET:urlStr parameters:parameters headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handelLog(remark, urlStr, @"GET", header, parameters, responseObject, NO, timeStamp);
                if (isCheck) {
                    handelResponse(parameters, failed, remark, responseObject, success, urlStr);
                } else {
                    if (success) success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                    handelError(task, error);
                }
            }];
        }
            break;
            
        case POST: {
            [[self sharedManager] POST:urlStr parameters:parameters headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handelLog(remark, urlStr, @"POST", header, parameters, responseObject, NO, timeStamp);
                if (isCheck) {
                    handelResponse(parameters, failed, remark, responseObject, success, urlStr);
                } else {
                    if (success) success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                    handelError(task, error);
                }
            }];
        }
            break;
            
        case PUT: {
            [[self sharedManager] PUT:urlStr parameters:parameters headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handelLog(remark, urlStr, @"PUT", header, parameters, responseObject, NO, timeStamp);
                if (isCheck) {
                    handelResponse(parameters, failed, remark, responseObject, success, urlStr);
                } else {
                    if (success) success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                    handelError(task, error);
                }
            }];
        }
            break;
            
        case DELETE: {
            [[self sharedManager] DELETE:urlStr parameters:parameters headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handelLog(remark, urlStr, @"DELETE", header, parameters, responseObject, NO, timeStamp);
                if (isCheck) {
                    handelResponse(parameters, failed, remark, responseObject, success, urlStr);
                } else {
                    if (success) success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                    handelError(task, error);
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 文件上传
+ (void)uploadImagesWithType:(NYSNetRequestType)type
                         url:(NSString * _Nonnull)url
                  parameters:(id)parameters
                        name:(NSString *)name
                       files:(NSArray *)files
                   fileNames:(NSArray<NSString *> *)fileNames
                  imageScale:(CGFloat)imageScale
                   imageType:(NSString *)imageType
                      remark:(NSString *)remark
          responseSerializer:(id <AFURLResponseSerialization> _Nonnull)responseSerializer
                    progress:(nullable void (^)(NSProgress * _Nonnull))process
                     success:(NYSNetRequestSuccess _Nullable )success
                      failed:(NYSNetRequestFailed _Nullable )failed {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    NSDictionary *header = [self headers];
    NSString *urlStr = [[[NYSKitManager sharedNYSKitManager] host] stringByAppendingString:url];
    
    [self sharedManager].responseSerializer = responseSerializer;
    [[self sharedManager] POST:urlStr parameters:parameters headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSUInteger i = 0; i < files.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(files[i], imageScale ? : 1.0f);
            // 生成文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = [NSString stringWithFormat:@"%@_%ld.%@",str,i+1,imageType?:@"png"];
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? [NSString stringWithFormat:@"%@.%@",fileNames[i],imageType?:@"png"] : imageFileName
                                    mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"png"]];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"上传中..."];
            process ? process(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        handelLog(remark, urlStr, @"POST", header, parameters, responseObject, NO, timeStamp);
        handelResponse(parameters, failed, remark, responseObject, success, urlStr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (failed) {
            failed(error);
            handelError(task, error);
        }
    }];
}

#pragma mark - 阿里云OSS图片上传
+ (void)ossUploadImageWithuUrlStr:(NSString *)urlStr
                       parameters:(id)parameters
                             name:(NSString *)name
                            image:(UIImage *)image
                        imageName:(NSString *)imageName
                       imageScale:(CGFloat)imageScale
                        imageType:(NSString *)imageType
                           remark:(id)remark
                         progress:(nullable void (^)(NSProgress * _Nonnull))process
                          success:(NYSNetRequestSuccess _Nullable )success
                           failed:(NYSNetRequestFailed _Nullable )failed {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    [[self sharedManager] POST:urlStr parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy_MM_ddHH:mm:ss";
        NSString *tempName = [formatter stringFromDate:[NSDate date]];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.65f);
        [formData appendPartWithFileData:imageData
                                    name:name
                                fileName:imageName ? [NSString stringWithFormat:@"%@.%@", imageName, imageType ?:@"png"] : [NSString stringWithFormat:@"%@.%@", tempName, imageType]
                                mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"png"]];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"上传中..."];
            process ? process(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handelLog(remark, urlStr, @"POST", nil, parameters, responseObject, NO, timeStamp);
        handelResponse(parameters, failed, remark, responseObject, success, urlStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(error);
            handelError(task, error);
        }
    }];
}

#pragma mark - JSON传参网络请求
+ (void)jsonNetworkRequestWithType:(NYSNetRequestType)type
                               url:(NSString * _Nonnull)url
                        parameters:(id)parameters
                            remark:(NSString * _Nullable)remark
                           success:(NYSNetRequestSuccess)success
                            failed:(NYSNetRequestFailed)failed {
    [self jsonRequestWithType:type url:url parameters:parameters responseSerializer:[AFJSONResponseSerializer serializer] isCheck:YES remark:remark success:success failed:failed];
}

+ (void)jsonNoCheckNetworkRequestWithType:(NYSNetRequestType)type
                                      url:(NSString * _Nonnull)url
                               parameters:(id)parameters
                                   remark:(NSString * _Nullable)remark
                                  success:(NYSNetRequestSuccess)success
                                   failed:(NYSNetRequestFailed)failed {
    [self jsonRequestWithType:type url:url parameters:parameters responseSerializer:[AFJSONResponseSerializer serializer] isCheck:NO remark:remark success:success failed:failed];
}

+ (void)jsonRequestWithType:(NYSNetRequestType)type
                        url:(NSString * _Nonnull)url
                 parameters:(id)parameters
         responseSerializer:(id <AFURLResponseSerialization> _Nonnull)responseSerializer
                    isCheck:(BOOL)isCheck
                     remark:(NSString * _Nullable)remark
                    success:(NYSNetRequestSuccess)success
                     failed:(NYSNetRequestFailed)failed {
    [self sharedManager];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    // 加载动画-延时执行
    [self performSelector:@selector(showLoadingAnimation) withObject:nil afterDelay:ShowDelayLoading];
    
    NSString *urlStr = [[[NYSKitManager sharedNYSKitManager] host] stringByAppendingString:url];
    if ([url containsString:@"http"]) {
        urlStr = url;
    }
    
    NSString *method = @"";
    switch (type) {
        case GET:
            method = @"GET";
            break;
        case POST:
            method = @"POST";
            break;
        case PUT:
            method = @"PUT";
            break;
        case DELETE:
            method = @"DELETE";
            break;
        default:
            break;
    }
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlStr parameters:parameters error:nil];
    [request setAllHTTPHeaderFields:[self headers]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置cookie
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cookie = [defaults objectForKey:@"cookie.name"];
    NSString *cookieValue = [defaults objectForKey:@"cookie.value"];
    if (cookie && cookieValue)
        [request setValue:[NSString stringWithFormat:@"%@=%@", cookie, cookieValue] forHTTPHeaderField:@"Cookie"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = responseSerializer;
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request
                                               uploadProgress:nil
                                             downloadProgress:nil
                                            completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [SVProgressHUD dismissWithDelay:1.0f];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoadingAnimation) object:nil];
        
        handelLog(remark, urlStr, method, [request allHTTPHeaderFields], parameters, responseObject, YES, timeStamp);
        if (!error) {
            // 获取cookie
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in [cookieJar cookies]) {
                if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:cookie.name forKey:@"cookie.name"];
                    [defaults setObject:cookie.value forKey:@"cookie.value"];
                    [defaults synchronize];
                }
            }
            
            if (isCheck) {
                handelResponse(parameters, failed, remark, responseObject, success, urlStr);
            } else {
                if (success) success(responseObject);
            }
            
        } else {
            DBGLog(@"\n[%@]\n%@", @"❌错误", error.localizedDescription);
            if (failed) {
                failed(error);
                handelError(task, error);
            }
        }
    }];
    
    [task resume];
}

#pragma mark - Mock
+ (void)mockRequestWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url parameters:(id)parameters remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed {
    // url: 路径：文件名xxx.json || 路径xx/xx/xxx.json
    NSString *pattern = @"/|\\"; // 使用正则表达式判断是否包含斜杠或反斜杠
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult *isPath = [regex firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    NSString *filePath = nil;
    if (isPath) {
        filePath = url;
    } else {
        NSArray<NSString *> *file =  [url componentsSeparatedByString:@"."];
        filePath = [[NSBundle mainBundle] pathForResource:file.firstObject ofType:file.lastObject];
    }
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    if (jsonData) {
        NSError *error = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error) {
            DBGLog(@"\n[%@]\n%@", @"❌错误", error.localizedDescription);
            if (failed) {
                failed(error);
                handelError(nil, error);
            }
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MockDelayLoading * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                handelResponse(parameters, failed, remark, jsonDictionary, success, @"Mock");
            });
        }
    } else {
        if (failed)
            failed(nil);
        DBGLog(@"\n[%@]\n%@", @"❌错误", @"Failed to read JSON file.");
    }
}

/// JSON样式编码
/// - Parameter dict: 字典
+ (NSString *)jsonPrettyStringEncoded:(NSDictionary *)dict {
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

#pragma mark - 响应体处理
static void handelResponse(id parameters, NYSNetRequestFailed  _Nullable failed, NSString *remark, id  _Nullable responseObject, NYSNetRequestSuccess  _Nullable success, NSString * _Nonnull url) {
    // 非字典类型不作合法性校验
    if (![responseObject isKindOfClass:NSDictionary.class]) {
        if (success) success(responseObject);
        return;
    }
    
    NSString *msg = @"unknown error"; // 错误信息
    for (NSString *key in [[[NYSKitManager sharedNYSKitManager] msgKey] componentsSeparatedByString:@","]) {
        NSString *message = [responseObject objectForKey:key];
        if (![NYSTools isBlankString:message]) {
            msg = message;
            break;
        }
    }
    
    // 通过判断字典keys获取api状态值
    NSInteger code = -1;
    if ([[(NSDictionary *)responseObject allKeys] containsObject:@"failed"]) {
        code = [[responseObject objectForKey:@"failed"] boolValue] ? -1 : 0;
    } else if ([[(NSDictionary *)responseObject allKeys] containsObject:@"code"]) {
        code = [[responseObject objectForKey:@"code"] integerValue];
    } else if ([[(NSDictionary *)responseObject allKeys] containsObject:@"status"]) {
        code = [[responseObject objectForKey:@"status"] integerValue];
    } else {
        if (success) success(responseObject);
        return;
    }
    
    NSArray *normalCodeArray = [[[NYSKitManager sharedNYSKitManager] normalCode] componentsSeparatedByString:@","];
    BOOL isNormal = [normalCodeArray containsObject:[NSString stringWithFormat:@"%ld", code]];
    if (isNormal) { // 正常返回
        if (success) {
            NSString *dataKey = [[NYSKitManager sharedNYSKitManager] dataKey];
            [NYSTools isBlankString:dataKey] ? success(responseObject) : success(responseObject[dataKey]);
        }
        return;
        
    } else if (code == [[[NYSKitManager sharedNYSKitManager] kickedCode] integerValue]) { // 强制下线
        [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationOnKick object:msg];
        
    } else if (code == [[[NYSKitManager sharedNYSKitManager] tokenInvalidCode] integerValue]) { // token失效
        NSString *tokenInvalidMessage = [[NYSKitManager sharedNYSKitManager] tokenInvalidMessage];
        if ([msg containsString:tokenInvalidMessage] || [NYSTools isBlankString:tokenInvalidMessage]) { // 防止后端token失效的code不唯一
            [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationTokenInvalidation object:msg];
        }
        
    } else {
        // Err Msg Toast
        if ([[NYSKitManager sharedNYSKitManager] isAlwaysShowErrorMsg])
            [NYSTools showBottomToast:msg];
    }
    
    if (failed) {
        NSError *error = [NSError errorWithDomain:@"NYSNetRequestErrorDomain" code:code userInfo:@{NSLocalizedDescriptionKey:msg}];
        failed(error);
    }
}

#pragma mark - 错误码处理
static void handelError(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = httpResponse.statusCode;
    
    NSString *msg = nil;
    switch (error.code) {
        case -1001:
            msg = @"Time Out";
            break;
        case -1004:
            msg = @"Unable Connect To Server";
            break;
        case -1009:
            msg = @"Network Unavailable";
            break;
        case -1011:
            msg = @"Server Unavailable";
            break;
        default:
            msg = error.localizedDescription;
    }
    
    if (statusCode == 401 || [error.localizedDescription containsString:@"401"]) { // unauthorized
        [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationTokenInvalidation object:msg];
        
    } else {
        [NYSTools showBottomToast:msg];
    }
#ifdef DEBUG
    NSLog(@"❌%@", error);
#endif
}

#pragma mark - 日志打印
static void handelLog(NSString *remark, NSString *urlStr, NSString *type, NSDictionary *header, NSDictionary *parameters, id responseObject, BOOL isJsosn, NSTimeInterval timeStamp) {
    id resp = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        resp = [NYSNetRequest jsonPrettyStringEncoded:responseObject];
    } else {
        resp = responseObject;
    }
    
    DBGLog(@"[%@]%@->📩:\n%@\n[Header]请求头:\n%@\n[%@]传参:\n%@\n[Response]响应:\n%@", type, remark, urlStr, header, isJsosn ? @"Json" : @"Form", [NYSNetRequest jsonPrettyStringEncoded:parameters], resp);
    
    if (isShowTimes) {
        NSDate *date = [NSDate date];
        NSTimeInterval times = [date timeIntervalSince1970] - timeStamp;
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:remark message:[NSString stringWithFormat:@"\n耗时：%.2f毫秒\n\n接口：%@", times *1000, urlStr] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)showLoadingAnimation {
    [NYSTools showLoading];
}

@end
