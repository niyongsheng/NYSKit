//
//  NYSJSHandler.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSJSHandler : NSObject <WKScriptMessageHandler>
@property (nonatomic, strong) UIViewController *webVC;
@property (nonatomic, strong) WKWebViewConfiguration *configuration;

- (instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration;

- (void)cancelHandler;

@end

NS_ASSUME_NONNULL_END
