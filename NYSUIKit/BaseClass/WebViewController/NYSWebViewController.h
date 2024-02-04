//
//  NYSWebViewController.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSWebViewController : NYSBaseViewController

/// 连接
@property (nonatomic, copy) NSString *urlStr;
/// 是否自动标题
@property (nonatomic, assign) BOOL autoTitle;
/// 进度条
@property (nonatomic, strong) UIProgressView *progressView;
/// 刷新控件
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, weak) WKWebViewConfiguration *webConfiguration;

- (instancetype)initWithUrlStr:(NSString *)urlStr;

- (void)loadHostPathURL:(NSString *)html;

/// 更新进度条
- (void)updateProgress:(double)progress;


/// JS主题适配
- (void)dayThemeJS:(WKWebView *)webview;
- (void)nightThemeJS:(WKWebView *)webview;
/// 灰色
- (void)grayThemeJS:(WKWebView *)webview;

@end

NS_ASSUME_NONNULL_END
