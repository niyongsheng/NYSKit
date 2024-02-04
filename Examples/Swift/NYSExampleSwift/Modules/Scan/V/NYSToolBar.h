//
//  NYSToolBar.h
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSToolBar : UIView
- (void)addQRCodeTarget:(id)aTarget action:(SEL)aAction;
- (void)addAlbumTarget:(id)aTarget action:(SEL)aAction;

- (void)showTorch;
- (void)dismissTorch;
@end

NS_ASSUME_NONNULL_END
