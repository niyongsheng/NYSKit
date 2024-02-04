//
//  NYSSystemLocation.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum : NSUInteger {
    NYSLocationTypeBaiDuMap,
    NYSLocationTypeAMap,
    NYSLocationTypeSysMap,
} NYSCoordinateType;

typedef void (^NYSLocationCompletion)(NSString * _Nonnull address, CLLocationCoordinate2D coordinate, NSError * _Nullable error);

@interface NYSSystemLocation : NSObject

#pragma mark - 系统定位
- (void)requestLocationSystem;
- (void)requestLocation:(NYSCoordinateType)coordinateType;

/// 定位结果
@property (nonatomic, copy) NYSLocationCompletion _Nullable completion;

@end
