//
//  NYSBaseView.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSBaseView : UIView

@property (weak, nonatomic) UIView *view;

- (void)setupView;

@end

NS_ASSUME_NONNULL_END
