//
//  NYSAppStorePay.m
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSAppStorePay.h"
#import "NYSTools.h"
#import "NYSKitPublicHeader.h"
#import <StoreKit/StoreKit.h>

@interface NYSAppStorePay()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic, strong) NSString *goodsId;/**<wct20180420  商品id*/

@end

@implementation NYSAppStorePay

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - 购买
- (void)starBuyToAppStore:(NSString *)goodsID {
    if ([SKPaymentQueue canMakePayments]) {
        [self getRequestAppleProduct:goodsID];
        
    } else {
        [NYSTools showToast:@"当前设备不支持购买"];
    }
}

#pragma mark - 请求苹果商品
- (void)getRequestAppleProduct:(NSString *)goodsID {
    self.goodsId = goodsID;
    
    // com.czchat.CZChat01就对应着苹果后台的商品ID,他们是通过这个ID进行联系的。
    NSArray *product = [[NSArray alloc] initWithObjects:goodsID,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    
    // SKProductsRequest参考链接：https://developer.apple.com/documentation/storekit/skproductsrequest
    // SKProductsRequest 一个对象，可以从App Store检索有关指定产品列表的本地化信息。
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];// 8.初始化请求
    request.delegate = self;
    [request start];
}

#pragma mark - 支付完成
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    __weak __typeof(self)weakSelf = self;
    NSURLRequest *appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:appstoreRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            DBGLog(@"Error fetching receipt data: %@", error);
        } else {
            // 获取到购买凭据
            NSString *transactionReceiptString = [data base64EncodedStringWithOptions:0];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(NYSAppStorePay:responseAppStorePaySuccess:error:)]) {
                // 通知后台交易成功，并把receipt传给后台验证
                [weakSelf.delegate NYSAppStorePay:weakSelf responseAppStorePaySuccess:@{@"receiptValue":transactionReceiptString} error:nil];
            }
            DBGLog(@"Receipt Data: %@", transactionReceiptString);
        }
    }];
    [dataTask resume];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - SKProductsRequestDelegate
// 接收到产品的返回信息,然后用返回的商品信息进行发起购买请求
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    
    if ([product count] == 0) {
        [NYSTools showToast:@"没有找到对应的商品"];
        return;
    }
    
    SKProduct *requestProduct = nil;
    for (SKProduct *pro in product) {
        DBGLog(@"Description: %@, Localized Title: %@, Localized Description: %@, Price: %@, Product Identifier: %@",
               [pro description],
               [pro localizedTitle],
               [pro localizedDescription],
               [pro price],
               [pro productIdentifier]);
        // 如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
        if([pro.productIdentifier isEqualToString:self.goodsId]){
            requestProduct = pro;
        }
    }
    // 发送购买请求，创建票据  这个时候就会有弹框了
    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];//将票据加入到交易队列
}

#pragma mark - SKRequestDelegate
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    DBGLog(@"error:%@", error);
}

// 反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request {
    DBGLog(@"信息反馈结束");
}


#pragma mark - SKPaymentTransactionObserver 监听购买结果
// 监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(NYSAppStorePay:responseAppStorePayStatusshow:error:)]) {
        [self.delegate NYSAppStorePay:self responseAppStorePayStatusshow:@{@"value":transaction} error:nil];
    }
    
    for (SKPaymentTransaction *tran in transaction) {
        
        DBGLog(@"%@",tran.payment.applicationUsername);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                DBGLog(@"交易完成");
                [self completeTransaction:tran];
            }
                break;
                
            case SKPaymentTransactionStatePurchasing:
                DBGLog(@"商品添加进列表");
                break;
                
            case SKPaymentTransactionStateRestored:
                DBGLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
                
            case SKPaymentTransactionStateFailed:
                DBGLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
                
            case SKPaymentTransactionStateDeferred:
                DBGLog(@"交易还在队列里面，但最终状态还没有决定");
                break;
                
            default:
                break;
        }
    }
}

@end
