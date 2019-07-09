//
//  JWLiveLyricsLabel.h
//  jwlive
//
//  Created by shuangwuxu on 2019/6/19.
//  Copyright © 2019 Mr ZnLG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JWLiveLyricsLabel : UIView
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UILabel *maskLabel;
@property (nonatomic, assign, readonly) BOOL isBeginAnimation;


- (void)setFont:(UIFont *)font;

- (void)setText:(NSString *)text;

- (void)setTextAlignment:(NSTextAlignment)textAlignment;

/**
 *  根据设置显示动画
 *
 *  @param timeArray     数组的内容是各个时间点，第一个必须是0，最后一个必须是总时间
 *  @param locationArray 对应各个时间点的位置，值从0~1，第一个必须是0，最后一个必须是1
 */
- (void)startLyricsAnimationWithTimeArray:(NSArray *)timeArray andLocationArray:(NSArray *)locationArray;

- (void)stopAnimation;

- (void)reAnimation;

- (void)pauseAnimation;

@end

NS_ASSUME_NONNULL_END
