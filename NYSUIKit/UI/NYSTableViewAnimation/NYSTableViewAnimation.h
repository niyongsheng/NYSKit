//
//  NYSTableViewAnimation.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NYSTableViewAnimationType){
    NYSTableViewAnimationTypeMove = 0,       // 从左至右依次滑入
    NYSTableViewAnimationTypeMoveSpring = 0, // 类似上一个
    NYSTableViewAnimationTypeAlpha,          // 从左至右依次滑入 回弹
    NYSTableViewAnimationTypeFall,           // 渐变从上至下依次进入
    NYSTableViewAnimationTypeShake,          // 从下自上依次堆叠
    NYSTableViewAnimationTypeOverTurn,       // 左右穿插
    NYSTableViewAnimationTypeToTop,          // 从上至下依次翻转
    NYSTableViewAnimationTypeSpringList,     // 从下自上依次堆叠
    NYSTableViewAnimationTypeShrinkToTop,    // 从上至下依次翻转 弹性
    NYSTableViewAnimationTypeLayDown,        // 从下自上收缩
    NYSTableViewAnimationTypeRote,           // 从上至下滚动展开
};

@interface NYSTableViewAnimation : NSObject<UICollisionBehaviorDelegate>


/// 显示cell动画
/// - Parameters:
///   - animationType: 动画类型
///   - tableView: 作用表格
+ (void)showWithAnimationType:(NYSTableViewAnimationType)animationType tableView:(UITableView *)tableView;

+ (void)moveAnimationWithTableView:(UITableView *)tableView;
+ (void)moveSpringAnimationWithTableView:(UITableView *)tableView;
+ (void)alphaAnimationWithTableView:(UITableView *)tableView;
+ (void)fallAnimationWithTableView:(UITableView *)tableView;
+ (void)shakeAnimationWithTableView:(UITableView *)tableView;
+ (void)overTurnAnimationWithTableView:(UITableView *)tableView;
+ (void)toTopAnimationWithTableView:(UITableView *)tableView;
+ (void)springListAnimationWithTableView:(UITableView *)tableView;
+ (void)shrinkToTopAnimationWithTableView:(UITableView *)tableView;
+ (void)layDownAnimationWithTableView:(UITableView *)tableView;
+ (void)roteAnimationWithTableView:(UITableView *)tableView;

@end
