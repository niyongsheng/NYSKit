//
//  NYSWebViewController.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSWebViewController.h"
#import "LEETheme.h"
#import "NYSJSHandler.h"
#import "NYSUIKitPublicHeader.h"
#import "NSBundle+NYSFramework.h"

@interface NYSWebViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic,strong) NYSJSHandler * jsHandler;
@property (nonatomic,assign) double lastProgress; // 上次进度条位置

@end

@implementation NYSWebViewController

- (instancetype)initWithUrlStr:(NSString *)urlStr {
    self = [super init];
    if (self) {
        [self loadWebUrl:urlStr];
    }
    return self;
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    
    [self loadWebUrl:urlStr];
}

-  (void)loadWebUrl:(NSString *)urlStr {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
}

- (void)setAutoTitle:(BOOL)autoTitle {
    _autoTitle = autoTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    // 重载+分享
    self.navigationItem.rightBarButtonItems = @[
        /*[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightReloadItemOnclicked:)],*/
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightShareItemOnclicked:)]
    ];
}

- (void)rightReloadItemOnclicked:(id)sender {
    [self.webView reload];
}

- (void)rightShareItemOnclicked:(id)sender {
    [NYSTools systemShare:@[self.webView.URL] controller:self completion:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
    }];
}

#pragma mark - webview
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences.javaScriptEnabled = YES; // 打开js交互
        configuration.allowsInlineMediaPlayback = YES; // 允许H5嵌入视频
        _webConfiguration = configuration;
        _jsHandler = [[NYSJSHandler alloc] initWithViewController:self configuration:configuration];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES; // 打开网页间的 滑动返回
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;

        [_webView addSubview:self.progressView];
        // 监听进度条
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        _webView.scrollView.refreshControl = self.refreshControl;
    }
    return _webView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(rightReloadItemOnclicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGFloat h = [NYSUIKitUtilities nys_statusBarHeight] + [NYSUIKitUtilities nys_navigationHeight];
        _progressView.frame = CGRectMake(0, h, [[UIScreen mainScreen] bounds].size.width, 1.15f);
        _progressView.transform = CGAffineTransformMakeScale(1.0, 0.5);
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

#pragma mark - 进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [self updateProgress:_webView.estimatedProgress];
}

#pragma mark - 更新进度条
- (void)updateProgress:(double)progress {
    self.progressView.alpha = 1;
    if (progress > _lastProgress) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    } else {
        [self.progressView setProgress:self.webView.estimatedProgress];
    }
    _lastProgress = progress;
    
    if (progress >= 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.alpha = 0;
            [self.progressView setProgress:0];
            self.lastProgress = 0;
        });
    }
}

#pragma mark - navigation delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.autoTitle) {
        self.title = webView.title;
    }
    [self updateProgress:webView.estimatedProgress];
    [self.refreshControl endRefreshing];
    
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        [self dayThemeJS:webView];
    } else {
        [self nightThemeJS:webView];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // 页面未完成加载前收到下一个请求，此时会触发(error=-999)
    if (error.code != -999)
        [self loadHostPathURL:@"load_error"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webView != self.webView) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    NSString *urlString = navigationAction.request.URL.absoluteString;
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 打开wkwebview禁用了电话和跳转appstore 通过这个方法打开
    UIApplication *app = [UIApplication sharedApplication];
    if ([url.scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    if ([url.absoluteString containsString:@"itunes.apple.com"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    if ([urlString hasPrefix:@"weixin://"]) {
        Boolean canOpenUrl = [[UIApplication sharedApplication] canOpenURL:url];
        if(canOpenUrl) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            // 允许跳转
            decisionHandler(WKNavigationActionPolicyAllow);
        }else {
            [NYSTools log:self.class msg:@"尚未安装微信"];
            // 不允许跳转
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    } else {
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - UIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (navigationAction.request.URL) {
        
        NSURL *url = navigationAction.request.URL;
        NSString *urlPath = url.absoluteString;
        if ([urlPath rangeOfString:@"https://"].location != NSNotFound || [urlPath rangeOfString:@"http://"].location != NSNotFound) {
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]]];
        }
    }
    
    return nil;
}

- (void)backBtnOnclicked:(UIButton *)sender {
    [self.webView stopLoading];
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super backBtnOnclicked:sender];
    }
}

/** 加载本地error html 文件 */
- (void)loadHostPathURL:(NSString *)html {
    // 获取html文件的路径
    NSBundle *bundle = [NSBundle bundleForClass:[NYSUIKitUtilities class]];
    if (!bundle) bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:html ofType:@"html"];

    // 获取html内容
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 加载html
    [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle bundleForClass:self.class] bundleURL]];
}

- (void)dayThemeJS:(WKWebView *)webview {
    [webview evaluateJavaScript:@"document.body.style.backgroundColor=\"#FFFFFF\"" completionHandler:nil];
}

- (void)nightThemeJS:(WKWebView *)webview {
    [webview evaluateJavaScript:@"document.body.style.backgroundColor=\"#000000\"" completionHandler:nil];
}

- (void)grayThemeJS:(WKWebView *)webview {
    [webview evaluateJavaScript:@"var filter = '-webkit-filter:grayscale(100%);-moz-filter:grayscale(100%); -ms-filter:grayscale(100%); -o-filter:grayscale(100%) filter:grayscale(100%);';document.getElementsByTagName('html')[0].style.filter = 'grayscale(100%)';" completionHandler:nil];
}

/// 设置主题
- (void)configTheme {
    [super configTheme];
    
    self.webView.lee_theme.LeeConfigBackgroundColor(@"normal_corner_style_bg_color");
    __weak typeof(self) weakSelf = self;
    self.webView.lee_theme
    .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
        __strong __typeof(weakSelf)strongWeak = weakSelf;
        [strongWeak dayThemeJS:item];
    })
    .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
        __strong __typeof(weakSelf)strongWeak = weakSelf;
        [strongWeak nightThemeJS:item];
    });
}

/// 屏幕旋转后重新布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGFloat duration = [coordinator transitionDuration];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        __strong __typeof(weakSelf)strongWeak = weakSelf;
        [strongWeak.webView setFrame:(CGRect){{0, 0}, size}];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_jsHandler cancelHandler];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    _webView = nil;
}

@end
