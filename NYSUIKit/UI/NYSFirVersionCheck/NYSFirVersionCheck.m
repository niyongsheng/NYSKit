//
//  NYSFirVersionCheck.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSFirVersionCheck.h"
#import "NYSUIKitPublicHeader.h"

@interface NYSFirVersionCheck()<UIAlertViewDelegate>

@property (nonatomic, copy) NSString *firAppID;
@property (nonatomic, copy) NSString *firAPIToken;
@property (nonatomic, copy) NSString *updateURL;
@property (nonatomic, strong) UIViewController *targetController;

@end

@implementation NYSFirVersionCheck

+ (instancetype)sharedInstance {
    static NYSFirVersionCheck *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NYSFirVersionCheck alloc] init];
    });
    return sharedInstance;
}

+ (void)setAPIToken:(NSString *)APIToken {
    [NYSFirVersionCheck sharedInstance].firAPIToken = APIToken;
}

+ (void)setTargetController:(UIViewController *)targetController {
    [NYSFirVersionCheck sharedInstance].targetController = targetController;
}

+ (void)setAppID:(NSString *)appID APIToken:(NSString *)APIToken {
    [NYSFirVersionCheck sharedInstance].firAppID = appID;
    [NYSFirVersionCheck sharedInstance].firAPIToken = APIToken;
}

+ (void)check {
    [self check:nil];
}

+ (void)check:(NYSFirVersionCheckCompletion)completion {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *idString = [NYSFirVersionCheck sharedInstance].firAppID;
    if (!idString) {
        idString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    }
    NSString *apiToken = [NYSFirVersionCheck sharedInstance].firAPIToken;
    if (apiToken && apiToken.length == 0) {
        [NYSTools log:self.class msg:@"FIR - 请先设置API Token"];
        return;
    }
    
    NSString *idUrlString = [NSString stringWithFormat:@"http://api.bq04.com/apps/latest/%@?api_token=%@" ,idString, apiToken];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:idUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [NYSTools log:self.class error:error];
            dispatch_semaphore_signal(sema);
        } else {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            [NYSTools log:self.class msg:[NSString stringWithFormat:@"FIR － 更新内容: \n%@ ", responseDictionary]];
            
            NSString *code = responseDictionary[@"code"];
            NSString *errors = responseDictionary[@"errors"];
            NSString *versionShort = responseDictionary[@"versionShort"];
            NSString *build = responseDictionary[@"build"];
            if (code && errors) {
                [NYSTools log:self.class msg:[NSString stringWithFormat:@"FIR - 新版本检测失败! (%@,%@)", code, errors]];
                
            } else {
                NSString *update_url = responseDictionary[@"update_url"];
                [NYSFirVersionCheck sharedInstance].updateURL = update_url;
                NSString *currentBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
                
                int relt = [self convertVersion:versionShort v2:appVersion];
                if (relt == 1) { // 版本号升级
                    if (completion) {
                        completion(responseDictionary);
                    } else {
                        [self showAlert:responseDictionary];
                    }
                    
                } else if (relt == 0) { // 构建号升级
                    if (completion) {
                        completion(responseDictionary);
                    } else {
                        [self showAlert:responseDictionary];
                    }
                }
            }
            dispatch_semaphore_signal(sema);
        }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

/// 显示系统样式更新弹框
/// - Parameter urlStr: 更新信息
+ (void)showAlert:(NSDictionary *)responseDictionary {
    NSString *build = responseDictionary[@"build"];
    NSString *version = [self nullToString:responseDictionary[@"versionShort"]];
    NSString *changelog = [self nullToString:responseDictionary[@"changelog"]];
    NSString *title = NSLocalizedStringFromTable(@"TipsAppUpdate", @"InfoPlist", nil);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@:%@(%@)", title, version, build] message:changelog preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *laterAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"AppUpdate", @"InfoPlist", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseDictionary[@"update_url"]] options:@{} completionHandler:nil];
            
        }];
        [alertController addAction:laterAction];
        [alertController addAction:okAction];
        if ([NYSFirVersionCheck sharedInstance].targetController)
            [[NYSFirVersionCheck sharedInstance].targetController presentViewController:alertController animated:YES completion:nil];
    });
}

+ (NSString *)nullToString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return (NSString *)string;
    }
}

/**
 比较版本号
 @param v1 版本1
 @param v2 版本2
 @return 返回0:相等 1:v1>v2 -1:v1<v2
 */
+ (int)convertVersion:(NSString *)v1 v2:(NSString *)v2 {
    // 去除杂质，只留下数字和点
    NSString *v1_n = [[v1 componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
    NSString *v2_n = [[v2 componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
    
    // 分解成数组
    NSArray *v1_arr = [v1_n componentsSeparatedByString:@"."];
    NSArray *v2_arr = [v2_n componentsSeparatedByString:@"."];
    
    // 取数组最大值
    NSInteger count = MAX(v1_arr.count, v2_arr.count);
    for (NSInteger i = 0; i < count; i++) {
        
        NSInteger v1_i = 0;
        NSInteger v2_i = 0;
        
        if (v1_arr.count > i) {
            v1_i = [v1_arr[i] integerValue];
        }
        if (v2_arr.count > i) {
            v2_i = [v2_arr[i] integerValue];
        }
        
        // 按顺序比较大小
        if (v1_i != v2_i) {
            return v1_i>v2_i?1:-1;
        }
    }
    // 循环结束，返回相等
    return 0;
}

@end
