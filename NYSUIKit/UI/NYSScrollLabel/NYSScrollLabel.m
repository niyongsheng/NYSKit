//
//  NYSScrollLabel.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSScrollLabel.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface NYSScrollLabel ()

@property (nonatomic, strong) UIView  *cycleScrollView;
/// 滚动前出现的Label
@property (nonatomic, strong) UILabel *scrollLabel;
/// 滚动后出现的Label 有循环效果
@property (nonatomic, strong) UILabel *cycleLabel;
@property (nonatomic, strong) CABasicAnimation *scrollAnimation;
@property (nonatomic, strong) CAAnimationGroup *scrollAnimationGroup;

@end


@implementation NYSScrollLabel

- (instancetype)init {
    if ([super init]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self initData];
    }
    return self;
}

/**
 *  初始化数据
 */
- (void)initData {
    self.clipsToBounds = YES;
    self.textFont = [UIFont systemFontOfSize:25];
    self.textColor = [UIColor whiteColor];
    
    self.duration = 5;
    self.space = 25;
    self.pauseTimeIntervalBeforeScroll = 0.7;
    
    [self addCycleScrollObserverNotification];
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupScrollLabel];
    [self scrollTextIfNeed];
}

#pragma mark -- 循环滚动Label

- (void)setupScrollLabel {
    if(self.text.length == 0) return;
    [self.cycleScrollView removeFromSuperview];
    [self addSubview:self.cycleScrollView];
    [self.cycleScrollView addSubview:self.scrollLabel];
    [self.cycleScrollView addSubview:self.cycleLabel];
    [self.cycleScrollView.layer removeAllAnimations];
}

- (void)scrollTextIfNeed {
    // 算出文字的size
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textFont} context:nil].size;
    
    CGFloat actulLableWidth = WIDTH;
    if(textSize.width + 10 > WIDTH) { //若文字的宽度超出view的宽度 则可以滚动
        actulLableWidth = textSize.width + self.space;
        self.cycleLabel.hidden = NO;
        // 动画持续时间
        self.scrollAnimation.duration = self.duration;
        
        self.scrollAnimation.toValue = @(-actulLableWidth);
        
        self.scrollAnimationGroup.duration = self.duration * 2;
        [self.cycleScrollView.layer addAnimation:self.scrollAnimationGroup forKey:nil];
    }
    // 设置滚动Label的frame
    self.scrollLabel.frame = CGRectMake(0, 0, actulLableWidth, HEIGHT);
    // 设置滚动后才能看到的Label的frame
    self.cycleLabel.frame = CGRectOffset(self.scrollLabel.frame, actulLableWidth, 0);
}

#pragma mark -- 进入后台 前台

- (void)addCycleScrollObserverNotification {
    // 活跃状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTextIfNeed) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 即将进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTextIfNeed) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 生命周期变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTextIfNeed) name:NYSScrollLabelViewDidAppearNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- getter
- (UIView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[UIView alloc] initWithFrame:self.bounds];
        _cycleScrollView.backgroundColor = [UIColor clearColor];
    }
    return _cycleScrollView;
}

- (UILabel *)scrollLabel {
    if (!_scrollLabel) {
        _scrollLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _scrollLabel.textColor = self.textColor;
        _scrollLabel.textAlignment = NSTextAlignmentLeft;
        _scrollLabel.font = self.textFont;
        _scrollLabel.text = self.text;
    }
    return _scrollLabel;
}

- (UILabel *)cycleLabel {
    if (!_cycleLabel) {
        _cycleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _cycleLabel.textColor = self.textColor;
        _cycleLabel.textAlignment = NSTextAlignmentCenter;
        _cycleLabel.font = self.textFont;
        _cycleLabel.text = self.text;
        _cycleLabel.hidden = YES;
    }
    return _cycleLabel;
}

- (CABasicAnimation *)scrollAnimation {
    if (!_scrollAnimation) {
        _scrollAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        _scrollAnimation.beginTime = self.pauseTimeIntervalBeforeScroll; // 延迟2秒
        _scrollAnimation.repeatCount = MAXFLOAT;
        _scrollAnimation.fromValue = @(0);
    }
    return _scrollAnimation;
}

- (CAAnimationGroup *)scrollAnimationGroup {
    if (!_scrollAnimationGroup) {
        _scrollAnimationGroup = [CAAnimationGroup animation];
        _scrollAnimationGroup.animations = @[[CABasicAnimation animation], self.scrollAnimation];
        _scrollAnimationGroup.repeatCount = MAXFLOAT;
        _scrollAnimationGroup.fillMode = kCAFillModeBackwards;
    }
    return _scrollAnimationGroup;
}

@end
