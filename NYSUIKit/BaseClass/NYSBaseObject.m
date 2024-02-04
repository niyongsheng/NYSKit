//
//  NYSBaseObject.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSBaseObject.h"
#import <objc/runtime.h>
#import <NYSKit/NYSKit.h>

@implementation NYSBaseObject

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"desc" : @"description",
        @"ID" : @"id",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"nysobjs" : [NYSBaseObject class],
        @"nysObjects" : @"NYSBaseObject"
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 处理字符串为null 改为@""
    for (NSString * key in [self bk_properties_string]) {
        if ([NYSTools stringIsNull:[self valueForKey:key]]) {
            [self setValue:@"" forKey:key];
        }
    }
    return YES;
}

/// 返回类型为NSString的成员变量
- (NSArray *)bk_properties_string {
    // 获取所有的成员变量
    unsigned int count = 0;// 记录属性个数
    Ivar * varList = class_copyIvarList([self class], &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i<count; ++i) {
        Ivar ivar = varList[i];
        NSString *ivarname = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([ivarname hasPrefix:@"_"]) {
            //把 _ 去掉，读取后面的
            ivarname = [ivarname substringFromIndex:1];
        }
        
        // 2.获取成员变量类型
        NSString * ivartype = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //把包含 @\" 的去掉，如 "@\"nsstring\"";-="">
        NSString * ivarType = [ivartype stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        // 3.获取类型为NSString的成员变量，加到数组进行返回
        if ([[self typeWithIvarType:ivarType] isEqualToString:@"NSString"]) {
            [mArray addObject:ivarname];
        }
    }
    return mArray;
}

/// 数据类型判断
- (NSString*)typeWithIvarType:(NSString*)ivarType {
    NSString * typeString = @"";
    if (![ivarType isKindOfClass:[NSString class]]) {
        return typeString;
    }
    if ([ivarType isEqualToString:@"i"]) {
        typeString = @"int";
    } else if ([ivarType isEqualToString:@"f"]) {
        typeString = @"float";
    } else if ([ivarType isEqualToString:@"d"]) {
        typeString = @"double|CGFloat";
    } else if ([ivarType isEqualToString:@"q"]) {
        typeString = @"NSInteger";
    } else if ([ivarType isEqualToString:@"B"]) {
        typeString = @"BOOL";
    } else {
        typeString = ivarType;
    }
    return typeString;
}

@end
