//
//  LyricsModel.h
//  MusicWeather
//
//  Created by shuangwuxu on 2019/6/20.
//  Copyright © 2019 Changwei Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LyricsModel : NSObject
@property(nonatomic,assign)BOOL isOtherLines;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,assign)CGFloat progress;
@property (nonatomic,assign)CGFloat eachLrcTime;//每行歌词总时间
@property (nonatomic,assign)CGSize lrcSize;//歌词高度宽度

@end

NS_ASSUME_NONNULL_END
