//
//  NYSTools.m
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2019 NYS. ALL rights reserved.
//

#import "NYSTools.h"
#import "NYSKitPublicHeader.h"
#import <MapKit/MapKit.h>
#import <Security/Security.h>
#import <AdSupport/AdSupport.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation NYSTools

#pragma mark - 核心动画相关
/**
 弹性缩放动画
 
 @param layer 作用图层
 */
+ (void)zoomToShow:(CALayer *)layer {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.5)]];
    
    animation.values = values;
    [layer addAnimation:animation forKey:nil];
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    if (@available(iOS 13.0, *)) {
        [feedBackGenertor impactOccurredWithIntensity:0.75];
    } else {
        [feedBackGenertor impactOccurred];
    }
}

/**
 左右晃动动画
 
 @param layer 作用图层
 */
+ (void)swayToShow:(CALayer *)layer {
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(0 /180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.37;
    keyAnimaion.repeatCount = 0;
    [layer addAnimation:keyAnimaion forKey:nil];
}

/**
 左右抖动动画（错误提醒）
 
 @param layer 左右图层
 */
+ (void)shakeAnimation:(CALayer *)layer {
    CGPoint position = [layer position];
    CGPoint y = CGPointMake(position.x - 3.0f, position.y);
    CGPoint x = CGPointMake(position.x + 3.0f, position.y);
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08f];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

/// 删除动画抖动效果
/// @param layer 作用图层
+ (void)deleteAnimation:(CALayer *)layer {

    CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1f;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    animation.fromValue= [NSValue valueWithCATransform3D:CATransform3DRotate(layer.transform,-0.08,0.0,0.0,0.08)];
    animation.toValue= [NSValue valueWithCATransform3D:CATransform3DRotate(layer.transform,0.08,0.0,0.0,0.08)];
    [layer addAnimation:animation forKey:@"wiggle"];
}

/**
 按钮左右抖动动画（错误提醒）
 
 @param button 作用按钮
 */
+ (void)shakToShow:(UIButton *)button {
    CGFloat t = 4.0;
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    button.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        button.transform = translateRight;
    } completion:nil];
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    if (@available(iOS 13.0, *)) {
        [feedBackGenertor impactOccurredWithIntensity:0.75];
    } else {
        [feedBackGenertor impactOccurred];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
        }];
    });
}

/**
 滚动动画
 
 @param duration 滚动显示
 @param layer 作用图层
 */
+ (void)animateTextChange:(CFTimeInterval)duration withLayer:(CALayer *)layer {
    CATransition *trans = [[CATransition alloc] init];
    trans.type = kCATransitionMoveIn;
    trans.subtype = kCATransitionFromTop;
    trans.duration = duration;
    trans.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [layer addAnimation:trans forKey:kCATransitionPush];
}


#pragma mark - 时间相关
/// 获取当前时间戳（单位：毫秒）
+ (NSString *)getNowTimeTimestamp {
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSInteger currentTimeMillis = (NSInteger)(currentTimeInterval * 1000);
    NSString *timeSp = [NSString stringWithFormat:@"%ld", currentTimeMillis];
    
    return timeSp;
}

/// 将时间戳转换成格式化的时间字符串
/// @param timestamp 时间戳（单位：毫秒）
/// @param format 格式（@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
+ (NSString *)transformTimestampToTime:(NSTimeInterval)timestamp format:(NSString *)format {
    if (!format) format = @"YYYY-MM-dd HH:mm:ss";
    
    NSTimeInterval interval = timestamp / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    [objDateformat setDateFormat:format];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}

/// 将某个时间转化成 时间戳（单位：毫秒）
/// @param formatTime 时间字符串
/// @param format 格式（@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制.
+ (NSTimeInterval)transformTimeToTimestamp:(NSString *)formatTime format:(NSString *)format {
    if (!format) format = @"YYYY-MM-dd HH:mm:ss";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime];
    
    // 日期转时间戳
    NSTimeInterval timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp * 1000;
}

/**
 时间戳转换成XX分钟之前
 @param timestamp 时间戳（单位：毫秒）
 */
+ (NSString *)timeBeforeInfoWithTimestamp:(NSInteger)timestamp {
    // 获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timestamp/1000; // 时间差
    
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前", year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前", month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前", day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前", hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前", minute];
    }else if(second > 0){
        return [NSString stringWithFormat:@"%d秒钟以前", second];
    }
    return [NSString stringWithFormat:@"刚刚"];
}

/// 计算年纪
/// @param birthdayStr >=4位生日字符串（1991-01-01）
+ (NSInteger)getAgeWithBirthdayString:(NSString *)birthdayStr {
    if (!birthdayStr) return 0;

    NSInteger birthdayYear = [[birthdayStr substringToIndex:4] integerValue];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    NSInteger currentYear = [[format stringFromDate:[NSDate date]] integerValue];
    
    return currentYear - birthdayYear;
}


#pragma mark - 圆角边框相关
/// 添加圆角阴影效果
/// @param theView 目标view
/// @param theColor 阴影颜色
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 10.0;

    theView.layer.cornerRadius = 10.0;
    
    theView.clipsToBounds=NO;
}


////图片圆角效果（贝塞尔曲线方式）
/// @param img 目标图片
/// @param cornerRadius 圆角尺度
+ (UIImage *)rh_bezierPathClip:(UIImage *)img
                  cornerRadius:(CGFloat)cornerRadius {
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    CGRect rect = (CGRect){CGPointZero, CGSizeMake(w, h)};

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    [img drawInRect:rect];
    UIImage *cornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cornerImage;
}

/// 添加部分圆角
/// @param view 作用域
/// @param corners UIRectCorner
/// @param radius 圆角半径
+ (void)addRoundedCorners:(UIView *)view
                  corners:(UIRectCorner)corners
                   radius:(CGFloat)radius {
    [self addRoundedCorners:view corners:corners radius:radius borderWidth:0 borderColor:UIColor.clearColor];
}

/// 添加部分圆角和边框
/// @param view 作用域
/// @param corners UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
/// @param radius 圆角半径
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
+ (void)addRoundedCorners:(UIView *)view
                  corners:(UIRectCorner)corners
                   radius:(CGFloat)radius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.frame;
    maskLayer.path = path.CGPath;
    maskLayer.lineWidth = borderWidth;
    maskLayer.strokeColor = borderColor.CGColor;
    view.layer.mask = maskLayer;
}


#pragma mark - 字符串处理相关
///  判断NSString值是否为空或null并转换为空字符串
/// @param string str
+ (NSString *)nullToString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return (NSString *)string;
    }
}

/// YES null    NO !null
/// @param string   str
+ (BOOL)isBlankString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return YES;
    } else {
        return NO;
    }
}

/// 拼音转换
/// @param str content
+ (NSString *)transformToPinyin:(NSString *)str {
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

/// 姓名加*
/// @param string 姓名
+ (NSString *)nameStringAsteriskHandle:(NSString *)string {
    if ([self isBlankString:string]) {
        return @"*";
    }
    
    if (string.length <= 2) {
        NSString *preStr = [string substringToIndex:1];
        return [preStr stringByAppendingString:@"*"];
    }
    
    if (string.length <= 3) {
        NSString *preStr = [string substringToIndex:1];
        NSString *sufStr = [string substringFromIndex:2];
        return [NSString stringWithFormat:@"%@*%@", preStr, sufStr];
    }
    
    NSString *preStr = [string substringToIndex:2];
    return [preStr stringByAppendingString:@"**"];
}

/// 号码加*
/// @param string 号码
+ (NSString *)phoneStringAsteriskHandle:(NSString *)string {
    if ([self isBlankString:string]) {
        return @"*";
    } else if (string.length <= 6) {
        return string;
    } else {
        NSRange middleRange = NSMakeRange(3, string.length - 6);
        NSString *middleString = [@"" stringByPaddingToLength:middleRange.length withString:@"*" startingAtIndex:0];
        NSString *result = [string stringByReplacingCharactersInRange:middleRange withString:middleString];
        return result;
    }
}

#pragma mark - 提示相关
/// Toast 头部
/// @param msg 内容
+ (void)showTopToast:(NSString *)msg {
    [self showToast:msg image:nil offset:UIOffsetMake(0, -[[UIScreen mainScreen] bounds].size.width * 0.3)];
}

/// Toast 底部
/// @param msg 内容
+ (void)showBottomToast:(NSString *)msg {
    [self showToast:msg image:nil offset:UIOffsetMake(0, [[UIScreen mainScreen] bounds].size.height * 0.4)];
}

+ (void)showToast:(NSString *)msg {
    [self showToast:msg image:nil offset:UIOffsetMake(0, 0)];
}

+ (void)showToast:(NSString *)msg image:(UIImage *)image {
    [self showToast:msg image:image offset:UIOffsetMake(0, 0)];
}

+ (void)showToast:(NSString *)msg image:(UIImage *)image offset:(UIOffset)offset {
    [SVProgressHUD setHapticsEnabled:YES];
    [SVProgressHUD setShouldTintImages:NO];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:12]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeNative)];
    [SVProgressHUD setOffsetFromCenter:offset];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showImage:image status:msg];
}

+ (void)showIconToast:(NSString *)msg isSuccess:(BOOL)isSuccess {
    [self showIconToast:msg isSuccess:isSuccess offset:UIOffsetMake(0, 0)];
}

+ (void)showIconToast:(NSString *)msg isSuccess:(BOOL)isSuccess offset:(UIOffset)offset {
    [SVProgressHUD setHapticsEnabled:YES];
    [SVProgressHUD setShouldTintImages:YES];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:12]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeNative)];
    [SVProgressHUD setOffsetFromCenter:offset];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    if (isSuccess) {
        [SVProgressHUD showSuccessWithStatus:msg];
    } else {
        [SVProgressHUD showInfoWithStatus:msg];
        [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    }
}

+ (void)showLoading {
    [self showLoading:nil];
}

/// 加载中
+ (void)showLoading:(NSString *)msg {
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 0)];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setHapticsEnabled:YES];
    [SVProgressHUD showWithStatus:msg];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}

+ (void)dismissWithCompletion:(NYSToolsDismissCompletion)completion {
    [SVProgressHUD dismissWithDelay:0.75f completion:completion];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(NYSToolsDismissCompletion)completion {
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

#pragma mark - 自动根据已安装的地图app跳转导航
/*
<key>LSApplicationQueriesSchemes</key>
<array>
   <string>iosamap</string>
   <string>baidumap</string>
</array>
*/
+ (void)navigateToAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate viewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择导航" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction*_Nonnullaction) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
        tolocation.name= address;
        [MKMapItem openMapsWithItems:@[currentLocation,tolocation]launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction*action2 = [UIAlertAction actionWithTitle:@"高德地图"style:UIAlertActionStyleDefault handler:^(UIAlertAction*_Nonnullaction) {
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",coordinate.latitude, coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlsting] options:@{UIApplicationOpenURLOptionsSourceApplicationKey: @YES} completionHandler:nil];
        }];
        [alert addAction:action2];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"百度地图"style:UIAlertActionStyleDefault handler:^(UIAlertAction*_Nonnullaction) {
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02", coordinate.latitude, coordinate.longitude, address] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlsting] options:@{UIApplicationOpenURLOptionsSourceApplicationKey: @YES} completionHandler:nil];
        }];
        [alert addAction:action3];
    }
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [alert addAction:action4];
    [viewController.navigationController presentViewController:alert animated:YES completion:nil];
}

+ (void)openAppSettings {
    NSURL *appSettingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:appSettingsURL]) {
        [[UIApplication sharedApplication] openURL:appSettingsURL options:@{} completionHandler:nil];
    }
}

+ (void)openURL:(NSString *)url {
    NSURL *URL = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
}

+ (void)callPhoneWithNumber:(NSString *)number {
    NSString *phoneNumber = [@"tel:" stringByAppendingString:number];
    NSURL *phoneURL = [NSURL URLWithString:phoneNumber];
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:nil];
    }
}

+ (void)sendEmailWithAddress:(NSString *)address {
    NSString *emailAddress = [@"mailto:" stringByAppendingString:address];
    NSURL *emailURL = [NSURL URLWithString:emailAddress];
    if ([[UIApplication sharedApplication] canOpenURL:emailURL]) {
        [[UIApplication sharedApplication] openURL:emailURL options:@{} completionHandler:nil];
    }
}

#pragma mark - 其他
/// 获取设备唯一标识（APP重装会改变）
+ (NSString *)getDeviceIdentifier {
    UIDevice *device = [UIDevice currentDevice];
    return [device identifierForVendor].UUIDString;
}

/// 获取IDFA
+ (NSString *)getIDFA {
    NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfaStr;
}

/**
 系统分享
 @param items 需要分享的类目，可以包括文字，图片，网址
 @param controller 视图控制器
 @param completion 回调
 */
+ (void)systemShare:(NSArray *)items controller:(UIViewController *)controller completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityVC.modalInPresentation = YES;
    activityVC.completionWithItemsHandler = completion;
    [controller presentViewController:activityVC animated:YES completion:nil];
}

/// 日志打印
/// @param text log
+ (void)log:(NSString *)text {
    [self log:text layer:2];
}

/// 日志打印
/// @param text log
/// @param layer 层级
+ (void)log:(NSString *)text layer:(NSInteger)layer {
#ifdef DEBUG
    // 获取调用栈信息
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    if (callStackSymbols.count > layer) {
        NSString *callerInfo = callStackSymbols[layer];
        NSArray<NSString *> *infoArr = [callerInfo componentsSeparatedByString:@"   "];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"HH:mm:ss.SSSSSSZ"];
        NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];

        printf("⏰TIME:%s Layer:%s Name:%s\n⛷️Stack:%s\n☕Log:%s\n----------------\n", [timeStr UTF8String], [infoArr.firstObject UTF8String], [infoArr[1] UTF8String], [infoArr.lastObject UTF8String], [text UTF8String]);
    } else {
        printf("Unable to retrieve caller info.");
    }
#endif
//    DBGLog(@"%@", text);
}

+ (void)log:(Class)from msg:(NSString *)msg {
    [self log:from obj:msg];
}

+ (void)log:(Class)from error:(NSError *)error {
    [self log:from obj:error];
}

/// 错误打印
/// @param from 调用类
/// @param obj 打印对象
+ (void)log:(Class)from obj:(id)obj {
#ifdef DEBUG
    if ([obj isKindOfClass:NSError.class]) {
        NSLog(@"[%@] ❌: {Code:%ld - Desc:%@};", NSStringFromClass(from), [(NSError *)obj code], [(NSError *)obj localizedDescription]);
    } else if ([obj isKindOfClass:NSString.class]) {
        NSLog(@"[%@] 📝: %@;", NSStringFromClass(from), obj);
    } else {
        NSLog(@"[%@] 📝: %@;", NSStringFromClass(from), obj);
    }
#endif
}

@end
