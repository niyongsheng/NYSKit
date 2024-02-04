//
//  PublicHeader.h
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#ifndef PublicHeader_h
#define PublicHeader_h

#import "NYSKitManager.h"

//-------------------打印日志-------------------------
// 打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)
// DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define NLog(format, ...) printf("^^类名:<地址:%p 控制器:%s:(行号:%d) > \n^^方法名:%s \n^^打印内容:%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else
#define NLog(format, ...)
#endif

// 完美解决Xcode NSLog打印不全的宏
#ifdef DEBUG
#define DBGLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];\
[dateFormatter setTimeZone:timeZone];\
[dateFormatter setDateFormat:@"HH:mm:ss.SSSSSSZ"];\
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"--TIME：%s【FILE：%s--LINE：%d】FUNCTION：%s\n%s\n",[str UTF8String],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__,__PRETTY_FUNCTION__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}
#else
# define DBGLog(...);
#endif

// DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#define NDLog(fmt, ...) { UIAlertController* alert = [UIAlertController alertControllerWithTitle:\
                            [NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__]\
                            message:[NSString stringWithFormat:fmt, ##__VA_ARGS__] preferredStyle:UIAlertControllerStyleAlert];\
                            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];\
                            [NRootViewController presentViewController:alert animated:YES completion:nil];}
#else
#define NDLog(fmt, ...)
#endif


#endif /* PublicHeader_h */
