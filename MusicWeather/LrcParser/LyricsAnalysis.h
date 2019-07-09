//
//  LyricsAnalysis.h
//  08-10-MusicPlayer
//
//  Created by Ibokan on 15/8/21.
//  Copyright (c) 2015年 Crazy凡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricsAnalysis : NSObject
@property (nonatomic,strong)NSString *ar;//演唱
@property (nonatomic,strong)NSString *ti;//歌曲名
@property (nonatomic,strong)NSString *al;//专辑名
@property (nonatomic,strong)NSString *by;//歌词作者
@property double t_time;//歌曲总时长
@property (nonatomic,strong)NSMutableArray *lrcArrayTime;//时间数组
@property (nonatomic,strong)NSMutableArray *lrcArrayStr;//歌词数组
@property (nonatomic,strong)NSMutableArray *lrcArrayEachTotalTime;//每行歌词总时间
@property (nonatomic,strong)NSMutableArray *lrcArrayEachLrcProgress;//每行平均进度


- (instancetype)init;
- (instancetype)initWithFileName:(NSString *)name ofType:(NSString *)type;
- (instancetype)initWithFilePath:(NSString *)filePath;
- (void)lyricsAnalysisWithFileName:(NSString *)name ofType:(NSString *)type;
- (void)lyricsAnalysisWithFilePath:(NSString *)filePath;
@end
