//
//  NYSAppStorePay.h
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>

@class NYSAppStorePay;

@protocol NYSAppStorePayDelegate <NSObject>;

@optional

/**
 内购支付成功回调
 @param appStorePay 当前类
 @param dicValue 返回值
 @param error 错误信息
 */
- (void)NYSAppStorePay:(NYSAppStorePay *)appStorePay responseAppStorePaySuccess:(NSDictionary *)dicValue error:(NSError*)error;

/**
 内购支付结果回调提示
 @param appStorePay 当前类
 @param dicValue 返回值
 @param error 错误信息
 */
- (void)NYSAppStorePay:(NYSAppStorePay *)appStorePay responseAppStorePayStatusshow:(NSDictionary *)dicValue error:(NSError*)error;

@end

@interface NYSAppStorePay : NSObject

@property (nonatomic, weak) id<NYSAppStorePayDelegate> delegate;

/**
 点击购买
 @param goodsID 商品id
 */
-(void)starBuyToAppStore:(NSString *)goodsID;

@end
