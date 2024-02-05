//
//  NYSRegularCheck.h
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//
//  ⚠️建议后端做最终合法性校验，前端只做必要性校验，降低多端调试成本；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSRegularCheck : NSObject

/// 正则校验邮箱号
+ (BOOL)checkMailInput:(NSString *)mail;
/// 正则校验AouthCode
+ (BOOL)checkAouthCode:(NSString *)auth;
/// 正则校验手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;
/// 车牌号验证
+ (BOOL)checkPlateNumber:(NSString *)plateNumber;
/// 正则校验昵称
+ (BOOL)checkNickname:(NSString *)nickname;
/// 正则校验用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password;
/// 正则校验用户身份证号
+ (BOOL)checkUserIdcard:(NSString *)idcard;
/// 正则校验员工号,12位的数字
+ (BOOL)checkEmployeeNumber:(NSString *)number;
/// 正则校验URL
+ (BOOL)checkURL:(NSString *)url;
/// 正则校验以C开头的18位字符
+ (BOOL)checkCtooNumberTo18:(NSString *)nickNumber;
/// 正则校验以C开头字符
+ (BOOL)checkCtooNumber:(NSString *)nickNumber;
/// 正则校验银行卡号是否正确
+ (BOOL)checkBankNumber:(NSString *)bankNumber;
/// 正则只能输入数字和字母
+ (BOOL)checkCharOrNumber:(NSString *)charNumber;
/// 正则只能输入汉字
+ (BOOL)checkChineseCharacters:(NSString *)name;
/// 正则验证金额数字
+ (BOOL)checkFloatMoney:(NSString *)money;
/// 正则验证精确到小数点后三位
+ (BOOL)checkThreeDecimalPlaces:(NSString *)value;
/// 自定义正则校验
+ (BOOL)checkCustomValue:(NSString *)value regular:(NSString *)regular;

@end


NS_ASSUME_NONNULL_END
