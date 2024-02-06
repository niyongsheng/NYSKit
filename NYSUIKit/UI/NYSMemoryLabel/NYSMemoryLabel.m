//
//  NYSMemoryLabel.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSMemoryLabel.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

#define kSize CGSizeMake(75, 20)

@implementation NYSMemoryLabel {
    CADisplayLink *_link;
    UIFont *_font;
    UIFont *_subFont;
    CGFloat _availableMemory;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:12];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:12];
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
    [self addGestureRecognizer:pan];
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    _availableMemory = [NSProcessInfo processInfo].physicalMemory / (1024 * 1024);
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(CADisplayLink *)link {
    
    CGFloat mem = [self memoryUsage];
    CGFloat progress = mem / _availableMemory;
    UIColor *color = [UIColor colorWithRed:progress green:1.0 - progress blue:0.0 alpha:1.0];
    NSString *memStr = [NSString stringWithFormat:@"%.2f MB", mem];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:memStr];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length - 2)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length - 2, 2)];
    [text addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(text.length - 6, 3)];
    
    self.attributedText = text;
}

- (CGFloat)memoryUsage {
    
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    
    if (kernelReturn != KERN_SUCCESS) {
        return NSNotFound;
    } else {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
    }
    
    return (CGFloat)memoryUsageInByte / (1024.0 * 1024.0);
}

- (CGFloat)physicalMemorySize {
    int mib[2];
    mib[0] = CTL_HW;
    mib[1] = HW_MEMSIZE;
    
    uint64_t physicalMemorySize;
    size_t length = sizeof(physicalMemorySize);
    
    if (sysctl(mib, 2, &physicalMemorySize, &length, NULL, 0) != 0) {
        return NSNotFound;
    }
    
    return physicalMemorySize / 1024.0 / 1024.0;
}

- (void)changePostion:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
    
    CGRect originalFrame = self.frame;
    
    originalFrame = [self changeXWithFrame:originalFrame point:point];
    originalFrame = [self changeYWithFrame:originalFrame point:point];
    
    self.frame = originalFrame;
    
    [pan setTranslation:CGPointZero inView:self];
    
    UIButton *button = (UIButton *)pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        button.enabled = NO;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
    } else {
        
        CGRect frame = self.frame;
        
        if (self.center.x <= [[UIScreen mainScreen] bounds].size.width / 2.0){
            frame.origin.x = 10;
        } else {
            frame.origin.x = [[UIScreen mainScreen] bounds].size.width - frame.size.width - 10;
        }
        
        if (frame.origin.y < 20) {
            frame.origin.y = 20;
        } else if (frame.origin.y + frame.size.height > [[UIScreen mainScreen] bounds].size.height) {
            frame.origin.y = [[UIScreen mainScreen] bounds].size.height - frame.size.height;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
        
        button.enabled = YES;
        
    }
}

- (CGRect)changeXWithFrame:(CGRect)originalFrame point:(CGPoint)point {
    BOOL q1 = originalFrame.origin.x >= 0;
    BOOL q2 = originalFrame.origin.x + originalFrame.size.width <= [[UIScreen mainScreen] bounds].size.width;
    
    if (q1 && q2) {
        originalFrame.origin.x += point.x;
    }
    return originalFrame;
}

- (CGRect)changeYWithFrame:(CGRect)originalFrame point:(CGPoint)point {
    
    BOOL q1 = originalFrame.origin.y >= 20;
    BOOL q2 = originalFrame.origin.y + originalFrame.size.height <= [[UIScreen mainScreen] bounds].size.height;
    if (q1 && q2) {
        originalFrame.origin.y += point.y;
    }
    return originalFrame;
}

@end
