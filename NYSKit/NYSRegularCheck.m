//
//  NYSRegularCheck.m
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

/**
 *  正则表达式简单说明
 *  语法：
 .       匹配除换行符以外的任意字符
 \w      匹配字母或数字或下划线或汉字
 \s      匹配任意的空白符
 \d      匹配数字
 \b      匹配单词的开始或结束
 ^       匹配字符串的开始
 $       匹配字符串的结束
 *       重复零次或更多次
 +       重复一次或更多次
 ?       重复零次或一次
 {n}     重复n次
 {n,}    重复n次或更多次
 {n,m}   重复n到m次
 \W      匹配任意不是字母，数字，下划线，汉字的字符
 \S      匹配任意不是空白符的字符
 \D      匹配任意非数字的字符
 \B      匹配不是单词开头或结束的位置
 [^x]    匹配除了x以外的任意字符
 [^aeiou]匹配除了aeiou这几个字母以外的任意字符
 *?      重复任意次，但尽可能少重复
 +?      重复1次或更多次，但尽可能少重复
 ??      重复0次或1次，但尽可能少重复
 {n,m}?  重复n到m次，但尽可能少重复
 {n,}?   重复n次以上，但尽可能少重复
 \a      报警字符(打印它的效果是电脑嘀一声)
 \b      通常是单词分界位置，但如果在字符类里使用代表退格
 \t      制表符，Tab
 \r      回车
 \v      竖向制表符
 \f      换页符
 \n      换行符
 \e      Escape
 \0nn     ASCII代码中八进制代码为nn的字符
 \xnn     ASCII代码中十六进制代码为nn的字符
 \unnnn     Unicode代码中十六进制代码为nnnn的字符
 \cN     ASCII控制字符。比如\cC代表Ctrl+C
 \A      字符串开头(类似^，但不受处理多行选项的影响)
 \Z      字符串结尾或行尾(不受处理多行选项的影响)
 \z      字符串结尾(类似$，但不受处理多行选项的影响)
 \G      当前搜索的开头
 \p{name}     Unicode中命名为name的字符类，例如\p{IsGreek}
 (?>exp)     贪婪子表达式
 (?<x>-<y>exp)     平衡组
 (?im-nsx:exp)     在子表达式exp中改变处理选项
 (?im-nsx)       为表达式后面的部分改变处理选项
 (?(exp)yes|no)     把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no
 (?(exp)yes)     同上，只是使用空表达式作为no
 (?(name)yes|no) 如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no
 (?(name)yes)     同上，只是使用空表达式作为no
 
 捕获
 (exp)               匹配exp,并捕获文本到自动命名的组里
 (?<name>exp)        匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
 (?:exp)             匹配exp,不捕获匹配的文本，也不给此分组分配组号
 零宽断言
 (?=exp)             匹配exp前面的位置
 (?<=exp)            匹配exp后面的位置
 (?!exp)             匹配后面跟的不是exp的位置
 (?<!exp)            匹配前面不是exp的位置
 注释
 (?#comment)         这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读
 
 *  表达式：\(?0\d{2}[) -]?\d{8}
 *  这个表达式可以匹配几种格式的电话号码，像(010)88886666，或022-22334455，或02912345678等。
 *  我们对它进行一些分析吧：
 *  首先是一个转义字符\(,它能出现0次或1次(?),然后是一个0，后面跟着2个数字(\d{2})，然后是)或-或空格中的一个，它出现1次或不出现(?)，
 *  最后是8个数字(\d{8})
 */

#import "NYSRegularCheck.h"

@implementation NYSRegularCheck

#pragma mark - 正则校验邮箱号
+ (BOOL)checkMailInput:(NSString *)mail {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

+ (BOOL)checkAouthCode:(NSString *)auth {
    
    auth = [auth stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *QQNum = @"[0-9]{6}";
    NSPredicate *QQTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",QQNum];
    
    return [QQTest evaluateWithObject:auth];
}

#pragma mark - 正则校验手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber {
    
    telNumber = [telNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNumber length] != 11) {
        return NO;
    }
    
    /**
     * 规则 -- 更新日期 2017-03-30
     * 手机号码: 13[0-9], 14[5,7,9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     *
     * [数据卡]: 14号段以前为上网卡专属号段，如中国联通的是145，中国移动的是147,中国电信的是149等等。
     * [虚拟运营商]: 170[1700/1701/1702(电信)、1703/1705/1706(移动)、1704/1707/1708/1709(联通)]、171（联通）
     * [卫星通信]: 1349
     */
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147(数据卡),150,151,152,157,158,159,170[5],178,182,183,184,187,188
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[8])|(18[2-4,7-8]))\\d{8}|(170[5])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145(数据卡),155,156,170[4,7-9],171,175,176,185,186
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[156])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149(数据卡),153,170[0-2],173,177,180,181,189
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNumber];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNumber];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNumber];
    
    if (isMatch_CM || isMatch_CT || isMatch_CU) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 正则校验用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password {
    
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma mark - 正则校验用户身份证号15或18位
+ (BOOL)checkUserIdcard:(NSString *)idcard {
    
    BOOL flag;
    if (idcard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [pred evaluateWithObject:idcard];
    return isMatch;
}

#pragma mark - 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber:(NSString *)number {
    
    NSString *pattern = @"^[0-9]{12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}

#pragma mark - 正则校验URL
+ (BOOL)checkURL:(NSString *)url {
    
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

#pragma mark - 正则校验昵称
+ (BOOL)checkNickname:(NSString *)nickname {
    
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isMatch = [pred evaluateWithObject:nickname];
    return isMatch;
}

#pragma mark - 正则校验以C开头的18位字符
+ (BOOL)checkCtooNumberTo18:(NSString *)nickNumber {
    
    NSString *nickNum=@"^C{1}[0-9]{18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNum];
    BOOL isMatch = [pred evaluateWithObject:nickNumber];
    return isMatch;
}
#pragma mark - 正则校验以C开头字符
+ (BOOL)checkCtooNumber:(NSString *)nickNumber {
    
    NSString *nickNum=@"^C{1}[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNum];
    BOOL isMatch = [pred evaluateWithObject:nickNumber];
    return isMatch;
}
#pragma mark - 正则校验银行卡号是否正确
+ (BOOL)checkBankNumber:(NSString *)bankNumber {
    
    NSString *bankNum=@"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:bankNumber];
    return isMatch;
}

#pragma mark - 正则只能输入数字和字母
+ (BOOL)checkCharOrNumber:(NSString *)charNumber {
    
    NSString *bankNum=@"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:charNumber];
    return isMatch;
}

#pragma mark - 车牌号验证
+ (BOOL)checkPlateNumber:(NSString *)plateNumber {
    
    NSString *bankNum = @"^([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼A-Z]{1}[a-zA-Z](([DF]((?![IO])[a-zA-Z0-9](?![IO]))[0-9]{4})|([0-9]{5}[DF]))|[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂]{1})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:plateNumber];
    return isMatch;
}

#pragma mark - 正则只能输入汉字
+ (BOOL)checkChineseCharacters:(NSString *)name {
    
    if ([name length] <= 1) {
        return NO;
    }
    NSString *bankNum = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:name];
    return isMatch;
}

#pragma mark - 正则验证金额数字
+ (BOOL)checkFloatMoney:(NSString *)money {
    
    NSString *moneyRegular = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,10}(([.]\\d{0,2})?)))?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moneyRegular];
    BOOL isMatch = [pred evaluateWithObject:money];
    return isMatch;
}

#pragma mark - 正则验证精确到小数点后三位
+ (BOOL)checkThreeDecimalPlaces:(NSString *)value {
    
    NSString *valueRegular = @"(\\+|\\-)?(([0]|(0[.]\\d{0,3}))|([1-9]\\d{0,10}(([.]\\d{0,3})?)))?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",valueRegular];
    BOOL isMatch = [pred evaluateWithObject:value];
    return isMatch;
}

#pragma mark - 自定义正则校验
+ (BOOL)checkCustomValue:(NSString *)value regular:(NSString *)regular {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    BOOL isMatch = [pred evaluateWithObject:value];
    return isMatch;
}

@end
