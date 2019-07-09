//
//  JWLiveLyricsLabel.m
//  jwlive
//
//  Created by shuangwuxu on 2019/6/19.
//  Copyright © 2019 Mr ZnLG. All rights reserved.
//

#import "JWLiveLyricsLabel.h"
@interface JWLiveLyricsLabel ()<CAAnimationDelegate>

@property (nonatomic, strong, readwrite) UILabel *textLabel;
@property (nonatomic, strong, readwrite) UILabel *maskLabel;
@property (nonatomic, strong) CALayer *maskLayer;//用来控制maskLabel渲染的layer
@property (nonatomic, assign, readwrite) BOOL isBeginAnimation;

@property (nonatomic, strong) UIColor *maskTextColor;
@property (nonatomic, strong) UIColor *maskBackgroundColor;

@end

@implementation JWLiveLyricsLabel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self addSubview:self.maskLabel];
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault {
    self.maskTextColor = [UIColor greenColor];
    self.maskBackgroundColor = [UIColor clearColor];
    
    self.maskLabel.textColor = self.maskTextColor;
    self.maskLabel.backgroundColor = self.maskBackgroundColor;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.anchorPoint = CGPointMake(0, 0.5);//注意，按默认的anchorPoint，width动画是同时像左右扩展的
    maskLayer.position = CGPointMake(0, CGRectGetHeight(self.bounds) / 2);
    maskLayer.bounds = CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds));
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.maskLabel.layer.mask = maskLayer;
    self.maskLayer = maskLayer;

}

#pragma mark - publicMethod


- (void)setFont:(UIFont *)font {
    self.textLabel.font = font;
    self.maskLabel.font = font;
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
    self.maskLabel.text = text;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.textLabel.textAlignment = textAlignment;
    self.maskLabel.textAlignment = textAlignment;
}


- (void)startLyricsAnimationWithTimeArray:(NSArray *)timeArray andLocationArray:(NSArray *)locationArray {
    
    CGFloat totalDuration = [timeArray.lastObject floatValue];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.width"];
    animation.delegate = self;
    NSMutableArray *keyTimeArray = [NSMutableArray array];
    NSMutableArray *widthArray = [NSMutableArray array];
    for (int i = 0 ; i < timeArray.count; i++) {
        CGFloat tempTime = [timeArray[i] floatValue] / totalDuration;
        [keyTimeArray addObject:@(tempTime)];
        CGFloat tempWidth = [locationArray[i] floatValue] * CGRectGetWidth(self.bounds);
        [widthArray addObject:@(tempWidth)];
    }
    animation.values = widthArray;
    animation.keyTimes = keyTimeArray;
    animation.duration = totalDuration;
    animation.calculationMode = kCAAnimationLinear;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.maskLayer addAnimation:animation forKey:@"kLyrcisAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"========动画开始");
    self.isBeginAnimation = YES;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"========动画结束");
    self.isBeginAnimation = NO;
    //    self.textLabel.textColor = [UIColor orangeColor];
}

- (void)stopAnimation {
    [self.maskLayer removeAllAnimations];
}

//暂停
-(void)pauseAnimation {
    [self pauseLayer:self.maskLayer];
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 让CALayer的时间停止走动
    layer.speed = 0.0;
    // 让CALayer的时间停留在pausedTime这个时刻
    layer.timeOffset = pausedTime;
}

- (void)reAnimation
{
    [self resumeLayer:self.maskLayer];
}

//恢复
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = layer.timeOffset;
    // 1. 让CALayer的时间继续行走
    layer.speed = 1.0;
    // 2. 取消上次记录的停留时刻
    layer.timeOffset = 0.0;
    // 3. 取消上次设置的时间
    layer.beginTime = 0.0;
    // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
    layer.beginTime = timeSincePause;
}

#pragma mark - property

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.adjustsFontSizeToFitWidth=YES;
        _textLabel.minimumScaleFactor=0.5;
    }
    return _textLabel;
}

- (UILabel *)maskLabel {
    if (!_maskLabel) {
        _maskLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _maskLabel.adjustsFontSizeToFitWidth=YES;
        _maskLabel.minimumScaleFactor=0.5;
    }
    return _maskLabel;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
    _maskLabel.frame = self.bounds;
}
@end
