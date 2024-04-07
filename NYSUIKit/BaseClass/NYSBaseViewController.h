//
//  NYSBaseViewController.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSError+NYS.h"

NS_ASSUME_NONNULL_BEGIN

/// 导航栏按钮回调
typedef void(^NYSNavItemCompletion)(UIButton *sender, NSInteger index);
typedef NS_ENUM(NSInteger, NYSNavItemAlignment) {
    NYSNavItemAlignmentRight,
    NYSNavItemAlignmentLeft
};

@interface NYSBaseViewController : UIViewController

/// 主数据源
@property (nonatomic, strong) NSMutableArray    *dataSourceArr;
@property (nonatomic, assign) NSInteger         pageNum;
@property (nonatomic, assign) UITableViewStyle  tableviewStyle;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UICollectionView  *collectionView;

/** 状态栏主题样式 */
@property (nonatomic, assign) UIStatusBarStyle customStatusBarStyle;
/** 是否隐藏导航栏 default :NO **/
@property (nonatomic, assign) BOOL isHidenNaviBar;
/** 是否显示返回按钮 default :YES */
@property (nonatomic, assign) BOOL isShowLiftBack;

/// 是否使用系统样式(UIRefreshControl) default :YES
@property (nonatomic, assign) BOOL isUseUIRefreshControl;
/// Empty \ Error info
@property (nonatomic, strong) NSError *emptyError;
@property (nonatomic, strong) UIImageView *backgroundImageView;

/** Theme UI VM, allow overridden */
- (void)configTheme;
- (void)setupUI;
- (void)bindViewModel;

/** Default pop back, allow overridden */
- (void)backBtnOnclicked:(UIButton *)sender;

/// Pull down refresh handler
- (void)headerRereshing;
/// Pull up refresh handler
- (void)footerRereshing;

/// 导航栏添加文字
- (void)addNavigationItemWithTitles:(NSArray<NSString *> *)titles alignment:(NYSNavItemAlignment)alignment completion:(NYSNavItemCompletion)completion;
/// 导航栏添加图标
- (void)addNavigationItemWithImages:(NSArray<UIImage *> *)images alignment:(NYSNavItemAlignment)alignment completion:(NYSNavItemCompletion)completion;
/// 导航栏添加按钮
- (void)addNavigationItems:(NSArray<UIButton *> *)buttonArray alignment:(NYSNavItemAlignment)alignment completion:(NYSNavItemCompletion)completion;

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - collectionView delegate / dataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - DZNEmptyDataSetSource
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
