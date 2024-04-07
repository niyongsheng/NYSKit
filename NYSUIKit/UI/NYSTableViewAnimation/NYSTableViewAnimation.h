//
//  NYSTableViewAnimation.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NYSTableViewAnimationType){
    NYSTableViewAnimationTypeMoveSpring = 0, // 从左至右依次滑入
    NYSTableViewAnimationTypeAlpha,          // 渐变从上至下依次进入
    NYSTableViewAnimationTypeFall,           // 从下自上依次掉落
    NYSTableViewAnimationTypeShake,          // 左右穿插
    NYSTableViewAnimationTypeOverTurn,       // 从上至下依次翻转
    NYSTableViewAnimationTypeToTop,          // 从下自上依次堆叠
    NYSTableViewAnimationTypeSpringList,     // 从上至下依次翻转 弹性
    NYSTableViewAnimationTypeShrinkToTop,    // 从下自上收缩
    NYSTableViewAnimationTypeLayDown,        // 从上至下滚动展开
    NYSTableViewAnimationTypeRote,           // 从上至下依次翻转
};

@interface NYSTableViewAnimation : NSObject<UICollisionBehaviorDelegate>

/// 显示cell动画
/// - Parameters:
///   - animationType: 动画类型
///   - tableView: 作用表格
+ (void)show:(NYSTableViewAnimationType)animationType tableView:(UITableView *)tableView;
+ (void)showWithAnimationType:(NYSTableViewAnimationType)animationType tableView:(UITableView *)tableView;

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
