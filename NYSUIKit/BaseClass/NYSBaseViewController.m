//
//  NYSBaseViewController.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSBaseViewController.h"
#import "LEETheme.h"
#import "CMPopTipView.h"
#import "WSScrollLabel.h"
#import "NYSUIKitPublicHeader.h"

#import "UIImage+NYS.h"
#import "UIButton+NYS.h"
#import "NSBundle+NYSFramework.h"

#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+EmptyDataSet.h"

#define NYSTopHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height

@interface NYSBaseViewController ()
<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@end

@implementation NYSBaseViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置主题
    [self configTheme];
    
    // 默认使用系统刷新样式
    [self setIsUseUIRefreshControl:YES];
    
    // 默认tableview样式
    _tableviewStyle = UITableViewStylePlain;
    
    // 默认占位信息
    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:nil]; // KVO
    self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow
                             description:[NSBundle nys_localizedStringForKey:@"NoData"]
                                  reason:@""
                              suggestion:[NSBundle nys_localizedStringForKey:@"Retry"]
                          placeholderImg:@"error"];
    // VM
    [self bindViewModel];
    // UI
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    if (_dataSourceArr.count == 0)
        self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow
                                 description:[NSBundle nys_localizedStringForKey:@"NoData"]
                                      reason:@""
                                  suggestion:[NSBundle nys_localizedStringForKey:@"Retry"]
                              placeholderImg:@"error"];
}

#pragma mark - UI
- (void)setupUI {
    // 默认显示返回按钮
    self.isShowLiftBack = YES;
    
    /**
     // 关闭拓展全屏布局，等效于automaticallyAdjustsScrollViewInsets = NO;
     self.edgesForExtendedLayout = UIRectEdgeNone;
     if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
     self.navigationController.navigationBar.translucent = YES;
     self.automaticallyAdjustsScrollViewInsets = YES;
     }
     */
}
- (void)bindViewModel {}
- (void)setCustomStatusBarStyle:(UIStatusBarStyle)StatusBarStyle {
    _customStatusBarStyle = StatusBarStyle;
    // 动态更新状态栏颜色
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Theme
- (void)configTheme {
    // 默认显示状态栏样式
    self.customStatusBarStyle = UIStatusBarStyleDefault;
    
    // 控制器背景色
    self.view.lee_theme.LeeConfigBackgroundColor(@"controller_view_bg_color");
    
#ifndef SWIFT_MODULE_NAME || __has_include(<WRNavigationBar/WRNavigationBar.h>)
    
#else
    // 导航栏适配
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.shadowColor = [UIColor clearColor];
        barApp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5]; // 背景色
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationController.navigationBar.standardAppearance = barApp;
    }
#endif
    
#ifdef NAppRoundStyle
    if (_tableView) _tableView.lee_theme.LeeConfigBackgroundColor(@"rounded_corner_style_bg_color");
    if (_collectionView) _collectionView.lee_theme.LeeConfigBackgroundColor(@"rounded_corner_style_bg_color");
#else
    if (_tableView) _tableView.lee_theme.LeeConfigBackgroundColor(@"normal_corner_style_bg_color");
    if (_collectionView) _collectionView.lee_theme.LeeConfigBackgroundColor(@"normal_corner_style_bg_color");
#endif
    
}

/// Lazy load主数据源
- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

/**
 *  Lazy load UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:_tableviewStyle];
        if (_tableviewStyle == UITableViewStyleGrouped) { // 处理顶部空白高度
            _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, CGFLOAT_MIN)];
        }
        if (@available(iOS 11.0, *)) {
            // 覆盖在UIScrollView上的内容不自动向下或向上移动以避开导航栏或工具栏(*建议在业务代码中自行控制)
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.lee_theme.LeeThemeChangingBlock(^(NSString * _Nonnull tag, id  _Nonnull item) {
            [item reloadEmptyDataSet];
        });
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        NSString *endStr = [NSBundle nys_localizedStringForKey:@"NoMore"];
        if (self.isUseUIRefreshControl) {
            // header refresh
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.tintColor = NAppThemeColor;
            [refreshControl addTarget:self action:@selector(headerRereshing) forControlEvents:UIControlEventValueChanged];
            _tableView.refreshControl = refreshControl;
            
            // footer refresh
            MJRefreshAutoNormalFooter *footter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.loadingView.color = NAppThemeColor;
            footter.loadingView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"footer_state_label_color");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _tableView.mj_footer = footter;
            
        } else {
            
            // 刷新数据的帧动画
            CGSize size = CGSizeMake(35, 35);
            NSMutableArray *refreshingImages = [NSMutableArray array];
            for (int i = 1; i <= 7; i++) {
                UIImage *image = [NYSUIKitUtilities imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
                [refreshingImages addObject:[image imageByResizeToSize:size]];
            }
            
            // header refresh
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            header.stateLabel.hidden = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = NO;
            [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [header setImages:@[[[NYSUIKitUtilities imageNamed:@"icon_refresh_up"] imageByResizeToSize:size]] duration:1.0f forState:MJRefreshStatePulling];
            [header setImages:@[UIImage.new, [[NYSUIKitUtilities imageNamed:@"icon_refresh_dropdown"] imageByResizeToSize:size]] duration:1.0f forState:MJRefreshStateIdle];
            _tableView.mj_header = header;
            
            // footer refresh
            MJRefreshAutoGifFooter *footter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"footer_state_label_color");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _tableView.mj_footer = footter;
        }
        
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, CGFLOAT_MIN)];
    }
    return _tableView;
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/**
 *  Lazy load collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) collectionViewLayout:flow];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _collectionView.contentInset = UIEdgeInsetsMake(NYSTopHeight, 0, 0, 0);
        }
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.lee_theme.LeeThemeChangingBlock(^(NSString * _Nonnull tag, id  _Nonnull item) {
            [item reloadEmptyDataSet];
        });
        
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        
        NSString *endStr = [NSBundle nys_localizedStringForKey:@"NoMore"];
        if (self.isUseUIRefreshControl) {
            // header refresh
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.tintColor = NAppThemeColor;
            [refreshControl addTarget:self action:@selector(headerRereshing) forControlEvents:UIControlEventValueChanged];
            _collectionView.refreshControl = refreshControl;
            
            // footer refresh
            MJRefreshAutoNormalFooter *footter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            [footter setAnimationDisabled];
            footter.refreshingTitleHidden = YES;
            footter.loadingView.color = NAppThemeColor;
            footter.loadingView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"footer_state_label_color");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _collectionView.mj_footer = footter;
            
        } else {
            // 刷新数据的帧动画
            CGSize size = CGSizeMake(35, 35);
            NSMutableArray *refreshingImages = [NSMutableArray array];
            for (int i = 1; i <= 7; i++) {
                UIImage *image = [NYSUIKitUtilities imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
                [refreshingImages addObject:[image imageByResizeToSize:size]];
            }
            
            // header refresh
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            header.stateLabel.hidden = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = NO;
            [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [header setImages:@[[[NYSUIKitUtilities imageNamed:@"icon_refresh_up"] imageByResizeToSize:size]] duration:1.0f forState:MJRefreshStatePulling];
            [header setImages:@[UIImage.new, [[NYSUIKitUtilities imageNamed:@"icon_refresh_dropdown"] imageByResizeToSize:size]] duration:1.0f forState:MJRefreshStateIdle];
            _collectionView.mj_header = header;
            
            // footer refresh
            MJRefreshAutoGifFooter *footter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"footer_state_label_color");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _collectionView.mj_footer = footter;
        }
        
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}

#pragma mark - collectionView delegate / dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
}

#pragma mark - MJRefresh Methods
- (void)headerRereshing {
    self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow
                             description:[NSBundle nys_localizedStringForKey:@"Loading"]
                                  reason:@""
                              suggestion:@""
                          placeholderImg:@"linkedin_binding_magnifier"];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_tableView) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.refreshControl endRefreshing];
        }
        
        if (self->_collectionView) {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.refreshControl endRefreshing];
        }
        
        self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow
                                 description:[NSBundle nys_localizedStringForKey:@"NoData"]
                                      reason:@""
                                  suggestion:[NSBundle nys_localizedStringForKey:@"Retry"]
                              placeholderImg:@"error"];
    });
}

- (void)footerRereshing {
    self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow
                             description:[NSBundle nys_localizedStringForKey:@"Loading"]
                                  reason:@""
                              suggestion:@""
                          placeholderImg:@"linkedin_binding_magnifier"];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_tableView)
            [weakSelf.tableView.mj_footer endRefreshing];
        
        if (self->_collectionView)
            [weakSelf.collectionView.mj_footer endRefreshing];
        
        self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow
                                 description:[NSBundle nys_localizedStringForKey:@"NoData"]
                                      reason:@""
                                  suggestion:[NSBundle nys_localizedStringForKey:@"Retry"]
                              placeholderImg:@"error"];
    });
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *placeholderStr = self.emptyError.userInfo[@"NSLocalizedPlaceholderImageName"];
    if ([NYSTools stringIsNull:placeholderStr]) {
        return [NYSUIKitUtilities imageNamed:@"error"];
    } else {
        return [NYSUIKitUtilities imageNamed:placeholderStr];
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:self.emptyError.localizedDescription attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:self.emptyError.localizedFailureReason ?:@"" attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *str = self.emptyError.localizedRecoverySuggestion;    
    NSMutableAttributedString *buttonAttStr = [[NSMutableAttributedString alloc] initWithString:str];
    [buttonAttStr addAttribute:NSForegroundColorAttributeName value:NAppThemeColor range:NSMakeRange(0, str.length)];
    [buttonAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, str.length)];
    [buttonAttStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];
    
    return buttonAttStr;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    UIEdgeInsets insets = scrollView.contentInset;
    return insets.top / 2;
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSAssert(_tableView || _collectionView, @"请先实例化组件");
    
    if (scrollView.refreshControl || scrollView.mj_header) {
        [self headerRereshing];
    } else if (scrollView.mj_footer) {
        [self footerRereshing];
    } else {
        [NYSTools showBottomToast:@"没有实现刷新方法"];
    }
}

#pragma mark - seter/getter
- (void)setEmptyError:(NSError *)emptyError {
    _emptyError = emptyError;
    
    if (_tableView) {
        [self.tableView reloadEmptyDataSet];
    } else if (_collectionView) {
        [self.collectionView reloadEmptyDataSet];
    }
}

#pragma mark - 是否显示返回按钮
- (void)setIsShowLiftBack:(BOOL)isShowLiftBack {
    _isShowLiftBack = isShowLiftBack;
    
    NSInteger VCCount = self.navigationController.viewControllers.count;
    // 当控制器不在导航栈顶 或者 控制器是被present出来的 -> 展示返回按钮
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil || self.tabBarController == nil)) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.lee_theme
            .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
                [(UIButton *)item setImage:[NYSUIKitUtilities imageNamed:@"back_icon_day"] forState:UIControlStateNormal];
            })
            .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
                [(UIButton *)item setImage:[NYSUIKitUtilities imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
            });
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(backBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *NULLBar = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}

- (void)backBtnOnclicked:(UIButton *)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark — 导航栏添加按钮方法

/// 导航栏添加文字按钮
/// - Parameters:
///   - titles: 文字数组
///   - alignment: 靠左\靠右
///   - completion: 点击回调
- (void)addNavigationItemWithTitles:(NSArray<NSString *> *)titles alignment:(NYSNavItemAlignment)alignment completion:(NYSNavItemCompletion)completion {
    NSMutableArray *buttonArray = [NSMutableArray array];
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.lee_theme.LeeConfigButtonTitleColor(@"default_nav_bar_tint_color", UIControlStateNormal);
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btn setTag:i];
        [btn sizeToFit];
        [buttonArray addObject:btn];
    }
    [self addNavigationItems:buttonArray alignment:alignment completion:completion];
}

/// 导航栏添加图标按钮
/// - Parameters:
///   - images: 图标数组
///   - alignment: 靠左\靠右
///   - completion: 点击回调
- (void)addNavigationItemWithImages:(NSArray<UIImage *> *)images alignment:(NYSNavItemAlignment)alignment completion:(NYSNavItemCompletion)completion {
    NSMutableArray *buttonArray = [NSMutableArray array];
    for (int i = 0; i < images.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setImage:images[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btn setTag:i];
        [btn sizeToFit];
        [buttonArray addObject:btn];
    }
    [self addNavigationItems:buttonArray alignment:alignment completion:completion];
}

/// 导航栏添加按钮(*指定tag值*)
/// - Parameters:
///   - buttonArray: 按钮数组
///   - alignment: 靠左\靠右
///   - completion: 点击回调
- (void)addNavigationItems:(NSArray<UIButton *> *)buttonArray alignment:(NYSNavItemAlignment)alignment completion:(NYSNavItemCompletion)completion {
    NSMutableArray<UIBarButtonItem *> *items = [[NSMutableArray alloc] init];
    for (int i = 0; i < buttonArray.count; i ++) {
        UIButton *button = buttonArray[i];
        [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *button) {
            if (completion)
                completion(button, button.tag);
        }];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [items addObject:item];
    }
    
    switch (alignment) {
        case NYSNavItemAlignmentRight:
            self.navigationItem.rightBarButtonItems = items;
            break;
            
        case NYSNavItemAlignmentLeft:
            self.navigationItem.leftBarButtonItems = items;
            break;
            
        default:
            break;
    }
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 支持的旋转方向
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 默认显示方向
    return UIInterfaceOrientationPortrait;
}

#pragma mark - 触控反馈
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 10.0, *)) {
#ifdef DEBUG
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGenertor impactOccurred];
#endif
    }
}

#pragma mark - 内存⚠️销毁
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"dataSource"];
}

@end
