//
//  LyricsAnalysis.m
//  08-10-MusicPlayer
//
//  Created by Ibokan on 15/8/21.
//  Copyright (c) 2015年 Crazy凡. All rights reserved.
//

#import "LyricsAnalysis.h"
#import "LyricsModel.h"

#import <UIKit/UIKit.h>


@interface LyricsAnalysis ()
@property double offset;//歌词时间调整变量
@end

@implementation LyricsAnalysis

//初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ar = [[NSString alloc]init];
        self.ti = [[NSString alloc]init];
        self.by = [[NSString alloc]init];
        self.al = [[NSString alloc]init];
        self.offset = 0;
        self.t_time = 0;
        self.lrcArrayStr = [[NSMutableArray alloc]init];//歌词数组初始化
        self.lrcArrayTime = [[NSMutableArray alloc]init];//时间数组初始化
        self.lrcArrayEachTotalTime = [[NSMutableArray alloc]init];//每行歌词总时间
        self.lrcArrayEachLrcProgress = [[NSMutableArray alloc] init];//每行平均进度;

    }
    return self;
}

//带文件名的初始化
- (instancetype)initWithFileName:(NSString *)name ofType:(NSString *)type
{
    self = [super init];
    if (self) {
        self = [self init];
        [self lyricsAnalysisWithFileName:name ofType:type];
    }
    return self;
}
//带文件路径的初始化
- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        self = [self init];
        [self lyricsAnalysisWithFilePath:filePath];
    }
    return self;
}
//处理文件名歌词
- (void)lyricsAnalysisWithFileName:(NSString *)name ofType:(NSString *)type
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:name ofType:type];
    [self lyricsAnalysisWithFilePath:path];
    //构建filepath
}

//处理文件路径
//- (void)lyricsAnalysisWithFilePath:(NSString *)filePath
//{
//     NSString *strlrc = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//     NSMutableArray * arraylrc = [[NSMutableArray alloc] initWithArray:[strlrc componentsSeparatedByString:@"\n"]];
//     NSArray *StrToInt = [NSArray arrayWithObjects:@"ar",@"ti",@"al",@"by",@"of",@"t_",nil];//NSString  switch 配置
//     BOOL flag = YES;
//     while(flag)
//     {
//         NSString *temp = arraylrc[0];
//         switch ((int)[StrToInt indexOfObject:[temp substringWithRange:NSMakeRange(1, 2)]])
//         {
//             case 0:self.ar = [[temp substringFromIndex:4]stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];break;
//             case 1:self.ti = [[temp substringFromIndex:4]stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];break;
//             case 2:self.al = [[temp substringFromIndex:4]stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];break;             case 3:self.by = [[temp substringFromIndex:4]stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];break;
//             case 4:self.offset = [[[temp substringFromIndex:8] stringByReplacingOccurrencesOfString:@"]" withString:@"\0"] doubleValue];break;
//             case 5:self.t_time = [[temp substringFromIndex:9] stringByReplacingOccurrencesOfString:@")]" withString:@"\0"];break;
//             default:flag = NO; break;
//         }
//         flag?[arraylrc removeObjectAtIndex:0]:nil;//判断是否需要移除已经被读取的信息（是歌词则不移除）
//     }// lrc时间的格式分3种:[mm:ss.SS]、[mm:ss:SS]、[mm:ss];第一种是标准形式，后面两种存在但是不标准;先把时间字符串按照“:”拆分，生成{mm ss.SS}、{mm ss SS}、{mm ss};对于1、3,直接取doubleValue即可;注意分钟*60;对于第二种情况需要单独处理SS(毫秒)位；
//     for (NSString *str in arraylrc) {
//         NSArray * ArrayTemp = [str componentsSeparatedByString:@"]"];//分割每一句歌词
//         {
//             NSArray * Arraytime = [[ArrayTemp[j] substringFromIndex:1] componentsSeparatedByString:@":"];//分割时间字符串             double timedouble = [Arraytime[0] doubleValue]*60.0 + [Arraytime[1] doubleValue];//处理分钟和秒
//             timedouble += Arraytime.count > 2 ? [[[NSString alloc]initWithFormat:@"0.%@",Arraytime[2]] doubleValue]:0;//处理毫秒位
//             timedouble += (self.offset / 1000.0);//时间调整
//             timedouble = timedouble > 0 ? timedouble : 0;//避免因为时间调整导致的时间<0
//             int i = 0;
//             while (i < self.lrcArrayTime.count && [self.lrcArrayTime[i++] doubleValue] < timedouble);//查找当前歌词的插入位置
//             [self.lrcArrayTime insertObject:[[NSString alloc]initWithFormat:@"%lf",timedouble] atIndex:i];//插入时间数组
//             [self.lrcArrayStr insertObject:ArrayTemp[ArrayTemp.count-1] atIndex:i];//插入歌词数组
//         }
//     }
//}

//处理文件路径
- (void)lyricsAnalysisWithFilePath:(NSString *)filePath
{
    NSString *strlrc = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray * arraylrc = [[NSMutableArray alloc] initWithArray:[strlrc componentsSeparatedByString:@"\n"]];
    //NSLog(@"%@",arraylrc);
    NSArray *StrToInt = [NSArray arrayWithObjects:@"ar",@"ti",@"al",@"by",@"of",@"t_",nil];//NSString  switch 配置
    BOOL flag = YES;
    while(flag)
    {
        NSString *temp = arraylrc[0];
        NSArray *ATT;
        if(temp.length > 4 )
        {
            //NSLog(@"%@\n\n\n",arraylrc);
            switch ((int)[StrToInt indexOfObject:[temp substringWithRange:NSMakeRange(1, 2)]])
            {
                case 0:self.ar = [[temp substringFromIndex:4]stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];break;
                case 1:self.ti = [[temp substringFromIndex:4]stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];break;
                case 2:self.al = [[temp substringFromIndex:4]stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];break;
                case 3:self.by = [[temp substringFromIndex:4]stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];break;
                case 4:self.offset = [[[temp substringFromIndex:8] stringByReplacingOccurrencesOfString:@"]" withString:@"\0"] doubleValue];break;
                case 5:ATT=[[[temp substringFromIndex:9] stringByReplacingOccurrencesOfString:@")]" withString:@"\0"]componentsSeparatedByString:@":"];
                    self.t_time = [ATT[0] doubleValue]*60 +[ATT[1] doubleValue];break;
                default:flag = NO; break;
            }
            flag?[arraylrc removeObjectAtIndex:0]:nil;//判断是否需要移除已经被读取的信息（是歌词则不移除）
        }else {
            [arraylrc removeObjectAtIndex:0];
        }
    }
    // lrc时间的格式分3种:[mm:ss.SS]、[mm:ss:SS]、[mm:ss];第一种是标准形式，后面两种存在但是不标准;先把时间字符串按照“:”拆分，生成{mm ss.SS}、{mm ss SS}、{mm ss};对于1、3,直接取doubleValue即可;注意分钟*60;对于第二种情况需要单独处理SS(毫秒)位；
    //NSLog(@"ar=%@ ti=%@ al=%@ by=%@ t_time=%lf",self.ar,self.ti,self.al,self.by,self.t_time);
    for (NSString *str in arraylrc) {
        NSArray * ArrayTemp = [str componentsSeparatedByString:@"]"];//分割每一句歌词
        for(int j = 0 ; j < ArrayTemp.count -1 ;j++)
        {
            NSArray * Arraytime = [[ArrayTemp[j] substringFromIndex:1] componentsSeparatedByString:@":"];//分割时间字符串
            double timedouble = [Arraytime[0] doubleValue]*60.0 + [Arraytime[1] doubleValue];//处理分钟和秒
            timedouble += Arraytime.count > 2 ? [[[NSString alloc]initWithFormat:@"0.%@",Arraytime[2]] doubleValue]:0;//处理毫秒位
            timedouble += (self.offset / 1000.0);//时间调整
            timedouble = timedouble > 0 ? timedouble : 0;//避免因为时间调整导致的时间<0
            int i = 0;
            while (i < self.lrcArrayTime.count && [self.lrcArrayTime[i++] doubleValue] < timedouble);//查找当前歌词的插入位置
            [self.lrcArrayTime insertObject:[[NSString alloc]initWithFormat:@"%lf",timedouble] atIndex:i];//插入时间数组
            if (i>0) {
                double lastTime = [self.lrcArrayTime[i-1] doubleValue];
                double curTime = timedouble;
                double totalTime = curTime - lastTime;
                NSLog(@"======= 总时间 ==%lf",totalTime);
                [self.lrcArrayEachTotalTime insertObject:[[NSString alloc]initWithFormat:@"%lf",totalTime] atIndex:i-1];//插入时间数组
            }
            NSString *str = ArrayTemp[ArrayTemp.count-1];
            NSString *strUrl = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
//                str = @"";
//            }
            [self.lrcArrayStr insertObject:strUrl atIndex:i];//插入歌词数组
        }
    }
    [self getEachLrcProgress];
}


- (void)getEachLrcProgress{
    for (int i = 0;i<self.lrcArrayStr.count-1;i++) {
        NSString *lrcStr = self.lrcArrayStr[i];
//        if (lrcStr.length==1) {
//            if([[lrcStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
//
//                NSLog(@"空格=%@=",lrcStr);
//                lrcStr = @"";
//            }
////            if ([lrcStr containsString:@"\0"]) {
////                NSLog(@"空格=%@=",lrcStr);
////            }
//        }
        CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(193, 1000) string:lrcStr];
        NSInteger count = size.height / [UIFont systemFontOfSize:16].lineHeight;
        CGFloat time = [self.lrcArrayEachTotalTime[i] floatValue];
        CGFloat progress = 193.0/time;
        LyricsModel *model = [[LyricsModel alloc] init];
        model.progress = progress;
        model.isOtherLines = count>1?YES:NO;
        model.count = count;
        model.eachLrcTime = time;
        model.lrcSize = size;
        [self.lrcArrayEachLrcProgress addObject:model];
    }
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string{
    
    NSDictionary *attrs = @{ NSFontAttributeName:font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
