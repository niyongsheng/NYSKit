//
//  NYSBaseWindow.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSBaseWindow.h"
#import "LEETheme.h"
#import "NYSUIKitPublicHeader.h"

@implementation NYSBaseWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 根据当前系统样式 启用相应的主题 以达到同步的效果
        if (@available(iOS 13.0, *)) {
            
            switch (self.traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleLight:
                    [LEETheme startTheme:DAY];
                    break;
                    
                case UIUserInterfaceStyleDark:
                    [LEETheme startTheme:NIGHT];
                    break;
                    
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    // 根据系统样式变化 重新启用相应的主题 以达到同步的效果
    if (@available(iOS 13.0, *)) {
        
        switch (self.traitCollection.userInterfaceStyle) {
            case UIUserInterfaceStyleLight:
                [LEETheme startTheme:DAY];
                break;
                
            case UIUserInterfaceStyleDark:
                [LEETheme startTheme:NIGHT];
                break;
                
            default:
                break;
        }
    }
}

@end
