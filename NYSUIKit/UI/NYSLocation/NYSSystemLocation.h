//
//  NYSSystemLocation.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum : NSUInteger {
    NYSLocationTypeSysMap = 0,  // GPS坐标(WGS-84)
    NYSLocationTypeAMap,        // 高德坐标(GCJ-02)
    NYSLocationTypeBaiDuMap     // 百度坐标(BD-09)
} NYSCoordinateType;

typedef void (^NYSLocationCompletion)(NSString * _Nonnull address, CLLocationCoordinate2D coordinate, NSError * _Nullable error);

@interface NYSSystemLocation : NSObject

#pragma mark - 开始定位
/// 单次定位
- (void)requestLocationSystem;
- (void)requestLocation:(NYSCoordinateType)coordinateType;

/// 持续定位
- (void)startUpdatingLocationSystem;
- (void)startUpdatingLocation:(NYSCoordinateType)coordinateType;

/// 逆地理编码
/// - Parameter currentLocation: 当前位置
- (void)reverseGeocodeWithLocation:(CLLocation * _Nonnull)currentLocation;
/// 定位结果
@property (nonatomic, copy) NYSLocationCompletion _Nullable completion;

@end
