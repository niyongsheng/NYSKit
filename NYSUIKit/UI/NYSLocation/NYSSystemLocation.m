//
//  NYSSystemLocation.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSSystemLocation.h"
#import "NYSUIKitPublicHeader.h"
#import "NYSLocationTransform.h"

@interface NYSSystemLocation ()
<
CLLocationManagerDelegate
>
@property (nonatomic, assign) NYSCoordinateType coordinateType;
@property (nonatomic, strong) CLLocationManager *sysLocationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@end

@implementation NYSSystemLocation

- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

- (CLLocationManager *)sysLocationManager {
    if (!_sysLocationManager) {
        _sysLocationManager = [[CLLocationManager alloc] init];
        [_sysLocationManager setDelegate:self];
        [_sysLocationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    return _sysLocationManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self.sysLocationManager requestWhenInUseAuthorization];
    }
    return self;
}

#pragma mark - 开始定位
/// 单次定位
- (void)requestLocationSystem {
    [self requestLocation:NYSLocationTypeSysMap];
}

/// 单次定位
/// - Parameter coordinateType: 坐标类型
- (void)requestLocation:(NYSCoordinateType)coordinateType {
    _coordinateType = coordinateType;
    
    [self.sysLocationManager requestLocation];
    [NYSTools showLoading];
    __weak __typeof(self)weakSelf = self;
    [NYSTools dismissWithDelay:10 completion:^{
        [weakSelf.sysLocationManager stopUpdatingLocation];
    }];
}

/// 持续定位
- (void)startUpdatingLocationSystem {
    [self startUpdatingLocation:NYSLocationTypeSysMap];
}

/// 持续定位
/// - Parameter coordinateType: 坐标类型
- (void)startUpdatingLocation:(NYSCoordinateType)coordinateType {
    _coordinateType = coordinateType;
    
    [self.sysLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    [NYSTools log:self.class msg:[NSString stringWithFormat:@"lat:%f-lng:%f-Accuracy:%.2fm", coordinate.latitude, coordinate.longitude, currentLocation.horizontalAccuracy]];
    [manager stopUpdatingLocation];
    
    [self reverseGeocodeWithLocation:currentLocation];
}

- (void)reverseGeocodeWithLocation:(CLLocation * _Nonnull)currentLocation {
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    if ([self.geoCoder isGeocoding]) return;
    
    // 系统逆地理编码
    __weak typeof(self) weakSelf = self;
    [self.geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        [NYSTools dismiss];
        
        if (error) {
            if (weakSelf.completion) {
                weakSelf.completion(@"", kCLLocationCoordinate2DInvalid, error);
            }
            [NYSTools log:self.class error:error];
            return;
        }
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@", placemark.administrativeArea, placemark.locality, placemark.subLocality, placemark.thoroughfare];
            if (weakSelf.completion) {
                switch (weakSelf.coordinateType) {
                    case NYSLocationTypeBaiDuMap: {
                        NYSLocationTransform *beforeTransform = [[NYSLocationTransform alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude];
                        NYSLocationTransform *afterTransform = [beforeTransform transformFromGPSToGD];
                        NYSLocationTransform *lastTransform = [afterTransform transformFromGDToBD];
                        weakSelf.completion(address, CLLocationCoordinate2DMake(lastTransform.latitude, lastTransform.longitude), error);
                    }
                        break;
                        
                    case NYSLocationTypeAMap: {
                        NYSLocationTransform *beforeTransform = [[NYSLocationTransform alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude];
                        NYSLocationTransform *afterTransform = [beforeTransform transformFromGPSToGD];
                        weakSelf.completion(address, CLLocationCoordinate2DMake(afterTransform.latitude, afterTransform.longitude), error);
                    }
                        break;
                        
                    case NYSLocationTypeSysMap:
                        weakSelf.completion(address, coordinate, error);
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error {
    [NYSTools log:self.class error:error];
    [NYSTools dismiss];
    
    if (_completion) {
        self.completion(@"", kCLLocationCoordinate2DInvalid, error);
    }
    
    [self.geoCoder cancelGeocode];
    [manager stopUpdatingLocation];
}

- (void)dealloc {
    [self.sysLocationManager stopUpdatingLocation];
    self.sysLocationManager.delegate = nil;
    self.sysLocationManager = nil;
    [self.geoCoder cancelGeocode];
}

@end
