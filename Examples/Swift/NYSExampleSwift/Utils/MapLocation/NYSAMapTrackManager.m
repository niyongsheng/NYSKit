//
//  NYSAMapTrackManager.m
//
//  📌高德猎鹰轨迹上报管理类
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

#import "NYSAMapTrackManager.h"
#import <AMapTrackKit/AMapTrackKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface NYSAMapTrackManager ()
<
AMapTrackManagerDelegate
>
@property (nonatomic, strong) AMapTrackManager *trackManager;
@end

@implementation NYSAMapTrackManager

+ (NYSAMapTrackManager *)sharedNYSAMapTrackManager {
    static NYSAMapTrackManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (CLLocationManager.authorizationStatus != kCLAuthorizationStatusAuthorizedAlways) {
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            [locationManager requestAlwaysAuthorization];
        }
        
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

/// 初始化轨迹上报
- (void)initTrackManager:(NSString *)serviceID terminalID:(NSString *)terminalID {
    [AMapServices sharedServices].apiKey = AmapKey;
    
    // Service ID 需要根据需要进行修改
    AMapTrackManagerOptions *option = [[AMapTrackManagerOptions alloc] init];
    option.serviceID = serviceID;
    
    // 初始化AMapTrackManager
    self.trackManager = [[AMapTrackManager alloc] initWithOptions:option];
    self.trackManager.delegate = self;
    
    // 配置定位属性
    [self.trackManager setAllowsBackgroundLocationUpdates:YES];
    [self.trackManager setPausesLocationUpdatesAutomatically:NO];
    [self.trackManager changeGatherAndPackTimeInterval:2 packTimeInterval:20];
    
    // 启动服务
    AMapTrackManagerServiceOption *serviceOption = [[AMapTrackManagerServiceOption alloc] init];
    serviceOption.terminalID = terminalID;
    [self.trackManager startServiceWithOptions:serviceOption];
}

/// 开始轨迹上报
- (void)startTrackService:(NSString *)trackID {
    self.trackManager.trackID = trackID;
    [self.trackManager startGatherAndPack];
}

/// 停止轨迹上报
- (void)stopTrackService {
    [self.trackManager stopGaterAndPack];
}

#pragma mark - AMapTrackManagerDelegate
- (void)amapTrackManager:(AMapTrackManager *)manager doRequireTemporaryFullAccuracyAuth:(CLLocationManager *)locationManager completion:(void (^)(NSError * _Nonnull))completion {
    if (@available(iOS 14.0, *)) {
        [locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"AMapTrackKitScene" completion:^(NSError * _Nullable error) {
            completion(error);
        }];
    }
}

- (void)amapTrackManager:(AMapTrackManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}

- (void)onStartService:(AMapTrackErrorCode)errorCode {
    NSLog(@"[猎鹰轨迹]onStartService:%ld", (long)errorCode);
}

- (void)onStartGatherAndPack:(AMapTrackErrorCode)errorCode {
    NSLog(@"[猎鹰轨迹]onStartGatherAndPack:%ld", (long)errorCode);
}

#pragma mark - 始终定位权限检查
- (void)checkLocationPermission:(void(^)(bool permit))completed {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^{
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"⚠️警告⚠️" message:[NSString stringWithFormat:@"请到设置->隐私->定位服务->【%@】切换到“始终“，否则将无法进行轨迹上报。", app_Name] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                [alertView addAction:sureAction];
                [alertView addAction:cancelAction];
                
                [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertView animated:YES completion:nil];
            });
            if (completed)
                completed(false);
            
        } else {
            if (completed)
                completed(true);
        }
    }];
}

@end
