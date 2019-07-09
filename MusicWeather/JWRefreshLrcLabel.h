//
//  JWRefreshLrcLabel.h
//  MusicWeather
//
//  Created by shuangwuxu on 2019/6/20.
//  Copyright © 2019 Changwei Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyricsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JWRefreshLrcLabel : UILabel
/**填充色，从左开始*/

@property(nonatomic,strong)UIColor *fillColor;

/**滑动进度*/

@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)BOOL isSecondLine;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)LyricsModel *model;
@end

NS_ASSUME_NONNULL_END
