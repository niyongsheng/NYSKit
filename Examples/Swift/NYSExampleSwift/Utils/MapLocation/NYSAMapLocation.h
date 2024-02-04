//
//  NYSAMapLocation.h
//
//  📌高德定位管理类
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

#import <NYSUIKit/NYSUIKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5
#define AmapKey @"cd46445b16c18384993146a79e520df9"

@interface NYSAMapLocation : NSObject

#pragma mark - 单次定位
- (void)requestLocation;
- (void)requestReGeocode;
- (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock _Nullable )completionBlock;

/// 停止定位
/// 调用此方法会cancel掉所有的单次定位请求，可以用来取消单次定位
- (void)cleanUpAction;

#pragma mark - 持续定位
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

/// 定位结果
@property (nonatomic, copy) NYSLocationCompletion _Nullable completion;

@end
