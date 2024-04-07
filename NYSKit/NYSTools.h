//
//  NYSTools.h
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2019 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^NYSToolsDismissCompletion)(void);

/// 工具类
@interface NYSTools : NSObject

#pragma mark - 核心动画相关
/**
 弹性缩放动画
 
 @param layer 作用图层
 */
+ (void)zoomToShow:(CALayer *)layer;

/**
 左右晃动动画
 
 @param layer 作用图层
 */
+ (void)swayToShow:(CALayer *)layer;

/**
 左右抖动动画（错误提醒）
 
 @param layer 左右图层
 */
+ (void)shakeAnimation:(CALayer *)layer;

/// 删除动画抖动效果
/// @param layer 作用图层
+ (void)deleteAnimation:(CALayer *)layer;

/**
 按钮左右抖动动画（错误提醒）
 
 @param button 作用按钮
 */
+ (void)shakToShow:(UIButton *)button;

/**
 滚动动画
 
 @param duration 滚动显示
 @param layer 作用图层
 */
+ (void)animateTextChange:(CFTimeInterval)duration withLayer:(CALayer *)layer;


#pragma mark - 时间相关
/// 获取当前时间戳（单位：毫秒）
+ (NSString *)getNowTimeTimestamp;

/// 将时间戳转换成格式化的时间字符串
/// @param timestamp 时间戳（单位：毫秒）
/// @param format 默认格式 "YYYY-MM-dd HH:mm:ss"
+ (NSString *)transformTimestampToTime:(NSTimeInterval)timestamp format:(NSString *)format;

/// 将某个时间转化成 时间戳（单位：毫秒）
/// @param formatTime 时间字符串
/// @param format 默认格式"YYYY-MM-dd HH:mm:ss"
+ (NSTimeInterval)transformTimeToTimestamp:(NSString *)formatTime format:(NSString *)format;

/**
 时间戳转换成XX分钟之前
 @param timestamp 时间戳（单位：毫秒）
 */
+ (NSString *)timeBeforeInfoWithTimestamp:(NSInteger)timestamp;

/// 计算年纪
/// @param birthdayStr 生日字符串（1991-01-01）
+ (NSInteger)getAgeWithBirthdayString:(NSString *)birthdayStr;


#pragma mark - 圆角边框相关
//// 添加圆角阴影
/// @param theView 目标view
/// @param theColor 阴影颜色
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor;


//// 图片圆角效果
/// @param img 目标图片
/// @param cornerRadius 圆角尺度
+ (UIImage *)rh_bezierPathClip:(UIImage *)img cornerRadius:(CGFloat)cornerRadius;

/// 添加部分圆角
/// @param view 作用域
/// @param corners UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
/// @param radius 圆角半径
+ (void)addRoundedCorners:(UIView *)view
                  corners:(UIRectCorner)corners
                   radius:(CGFloat)radius;
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
              borderColor:(UIColor *)borderColor;


#pragma mark - 字符串处理相关
/// 判断NSString值是否为空或null并转换为空字符串
/// @param string str
+ (NSString *)nullToString:(id)string;

/// YES null    NO !null
/// @param string   str
+ (BOOL)isBlankString:(id)string;

/// 拼音转换
/// @param str content
+ (NSString *)transformToPinyin:(NSString *)str;

/// 姓名加*
/// @param string 姓名
+ (NSString *)nameStringAsteriskHandle:(NSString *)string;

/// 号码加*
/// @param string 号码
+ (NSString *)phoneStringAsteriskHandle:(NSString *)string;


#pragma mark - 提示相关
/// Toast 头部
/// @param str 内容
+ (void)showTopToast:(NSString *)str;

/// Toast 底部
/// @param str 内容
+ (void)showBottomToast:(NSString *)str;

/// Toast居中显示
/// @param msg 内容
+ (void)showToast:(NSString *)msg;

+ (void)showToast:(NSString *)msg image:(UIImage *)image;
+ (void)showToast:(NSString *)msg image:(UIImage *)image offset:(UIOffset)offset;
+ (void)showIconToast:(NSString *)msg isSuccess:(BOOL)isSuccess;
+ (void)showIconToast:(NSString *)msg isSuccess:(BOOL)isSuccess offset:(UIOffset)offset;
+ (void)showLoading;
+ (void)showLoading:(NSString *)msg;
+ (void)dismiss;
+ (void)dismissWithCompletion:(NYSToolsDismissCompletion)completion;
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(NYSToolsDismissCompletion)completion;

#pragma mark - 自动根据已安装的地图app跳转导航
/*
<key>LSApplicationQueriesSchemes</key>
<array>
   <string>iosamap</string>
   <string>baidumap</string>
</array>
*/
+ (void)navigateToAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate viewController:(UIViewController *)viewController;

+ (void)openAppSetting;
+ (void)openURL:(NSString *)url;
+ (void)callPhoneWithNumber:(NSString *)number;
+ (void)sendEmailWithAddress:(NSString *)address;

#pragma mark - 其他
/// 获取设备唯一标识（APP重装会改变）
+ (NSString *)getDeviceIdentifier;

/// 获取IDFA
+ (NSString *)getIDFA;

/**
 系统分享
 @param items 需要分享的类目，可以包括文字，图片，网址
 @param controller 视图控制器
 @param completion 回调
 */
+ (void)systemShare:(NSArray *)items controller:(UIViewController *)controller completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;

/// 日志打印
/// @param text log
+ (void)log:(NSString *)text;

/// 日志打印
/// @param text log
/// @param layer 层级
+ (void)log:(NSString *)text layer:(NSInteger)layer;

+ (void)log:(Class)from obj:(id)obj;
+ (void)log:(Class)from msg:(NSString *)msg;
+ (void)log:(Class)from error:(NSError *)error;

@end
