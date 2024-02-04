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
@property (nonatomic, assign) BOOL isLocationUpdating;
@property (nonatomic, assign) NYSCoordinateType coordinateType;
@property (nonatomic, strong) CLLocationManager *sysLocationManager;

@end

@implementation NYSSystemLocation

- (instancetype)init {
    if (self = [super init]) {
        self.sysLocationManager = [[CLLocationManager alloc] init];
        [self.sysLocationManager setDelegate:self];
        [self.sysLocationManager requestWhenInUseAuthorization];
        [self.sysLocationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    return self;
}

#pragma mark - 系统定位
- (void)requestLocationSystem {
    [self requestLocation:NYSLocationTypeSysMap];
}

- (void)requestLocation:(NYSCoordinateType)coordinateType {
    _coordinateType = coordinateType;
    
    if (!self.isLocationUpdating) {
        self.isLocationUpdating = YES;
        [self.sysLocationManager startUpdatingLocation];
    } else {
        [NYSTools showIconToast:@"Location services disable" isSuccess:false offset:UIOffsetMake(0, 0)];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    [NYSTools log:self.class msg:[NSString stringWithFormat:@"lat:%f-lng:%f-Accuracy:%.2fm", coordinate.latitude, coordinate.longitude, currentLocation.horizontalAccuracy]];
    
    
    // 系统逆地理编码
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
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
    
    [manager stopUpdatingLocation];
    self.isLocationUpdating = NO;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error {
    self.isLocationUpdating = NO;
    [NYSTools log:self.class error:error];
    
    if (_completion) {
        self.completion(@"", kCLLocationCoordinate2DInvalid, error);
    }
}

- (void)dealloc {
    [self.sysLocationManager stopUpdatingLocation];
    self.sysLocationManager.delegate = nil;
    self.sysLocationManager = nil;
}

@end
