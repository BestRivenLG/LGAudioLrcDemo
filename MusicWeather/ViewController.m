//
//  ViewController.m
//  MusicWeather
//
//  Created by 张昌伟 on 16/2/22.
//  Copyright © 2016年 Changwei Zhang. All rights reserved.
//

#import "ViewController.h"
#import "LrcParser.h"
#import "LyricsAnalysis.h"
#import "JWLiveLrcCell.h"
#import "LyricsModel.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *lrcTable;

@property (strong,nonatomic) LrcParser* lrcContent;

@property (nonatomic,strong) NSTimer *timer;

@property (assign) NSInteger lastCurrentRow;
@property (assign) NSInteger currentRow;
@property (nonatomic,strong) NSArray *currentTotalTimeArr;

@property (nonatomic,copy) NSArray *songs;
@property (strong,nonatomic) LyricsAnalysis *lyriContent;
@property (assign,nonatomic) BOOL isScrollCurrentRow;

@end



@implementation ViewController
-(void) initPlayer{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle]  URLForResource:@"Dont" withExtension:@"mp3"] error:nil];//@"那就这样吧"
    self.player.numberOfLoops=10;
    [self.player prepareToPlay];
    [self.player play];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lrcTable.delegate=self;
    self.lrcTable.dataSource=self;
//    self.lrcContent=[[LrcParser alloc] init];
//    [self.lrcContent parseLrc];
    self.lyriContent = [[LyricsAnalysis alloc] initWithFileName:@"Dont" ofType:@"lrc"];
    [self.lrcTable reloadData];
    [self initPlayer];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
//    CADisplayLink* gameTimer;
//
//    gameTimer = [CADisplayLink displayLinkWithTarget:self
//
//                                            selector:@selector(updateTime)];
//
//    [gameTimer addToRunLoop:[NSRunLoop currentRunLoop]
//
//                    forMode:NSDefaultRunLoopMode];
    //
    
    
    
    UIImage *img=[UIImage imageNamed:@"wall1.jpg"];
    
    UIImageView *bgView=[[UIImageView alloc] initWithImage:img];
    //bgView.alpha=0.8;
    self.lrcTable.backgroundView=bgView;
    [bgView setImage:[self getBlurredImage:img]];
    
    [self.lrcTable registerClass:[JWLiveLrcCell class] forCellReuseIdentifier:@"JWLiveLrcCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lyriContent.lrcArrayStr.count;
//    return self.lrcContent.wordArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell=[self.lrcTable dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
////    cell.textLabel.text=self.lrcContent.wordArray[indexPath.row];
//    cell.textLabel.text=self.lyriContent.lrcArrayStr[indexPath.row];
//
//    if(indexPath.row==_currentRow)
//        cell.textLabel.textColor = [UIColor redColor];
//    else
//        cell.textLabel.textColor = [UIColor whiteColor];
//
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    cell.backgroundColor=[UIColor clearColor];
    //    cell.lrcLabel.text = self.lyriContent.lrcArrayStr[indexPath.row];

    
//    JWLiveLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWLiveLrcCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.lyricLabel.text = self.lyriContent.lrcArrayStr[indexPath.row];
//    NSArray *arr = @[];
//    if (indexPath.row<self.lyriContent.lrcArrayEachTotalTime.count) {
//        CGFloat totalTime = [self.lyriContent.lrcArrayEachTotalTime[indexPath.row] floatValue];
//        arr = @[@(0),@(totalTime)];
//    }
//
//    if(indexPath.row==_currentRow){
//        cell.lyricLabel.font = [UIFont systemFontOfSize:16];
//        if (!cell.lyricLabel.isBeginAnimation) {
//            if (arr.count>0) {
//                [cell.lyricLabel startLyricsAnimationWithTimeArray:arr andLocationArray:@[@(0),@(1)]];
//            }
//        }
////        cell.lrcLabel.font = [UIFont systemFontOfSize:16];
//    }else{
//        [cell.lyricLabel stopAnimation];
//        cell.lyricLabel.font = [UIFont systemFontOfSize:13];
////        cell.lrcLabel.font = [UIFont systemFontOfSize:13];
//    }

    JWLiveLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWLiveLrcCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.refreshLrcLabel.text = self.lyriContent.lrcArrayStr[indexPath.row];
    NSLog(@"=====%@===长度%ld",cell.refreshLrcLabel.text,cell.refreshLrcLabel.text.length);
    [cell.refreshLrcLabel sizeToFit];
    if(indexPath.row==_currentRow){
        cell.refreshLrcLabel.font = [UIFont systemFontOfSize:16];
        CGFloat progress = 0;
        if (indexPath.row<self.lyriContent.lrcArrayEachLrcProgress.count) {
            LyricsModel *model = self.lyriContent.lrcArrayEachLrcProgress[indexPath.row];
            cell.refreshLrcLabel.model = model;
            progress = model.progress;
        }
        cell.refreshLrcLabel.fillColor = [UIColor greenColor];
        cell.refreshLrcLabel.progress = progress;
    }else{
        cell.refreshLrcLabel.font = [UIFont systemFontOfSize:13];
        cell.refreshLrcLabel.progress = 0;
        cell.refreshLrcLabel.fillColor = [UIColor clearColor];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
    return 60;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 10;
//}

-(void) setPlayerUrl:(NSURL *)url{
    //[self.player ini
    
}






-(void) updateTime{
    float currentTime=self.player.currentTime;
    NSLog(@"%d:%d",(int)currentTime / 60, (int)currentTime % 60);
//    for (int i=0; i<self.lrcContent.timerArray.count; i++) {
    for (int i=0; i<self.lyriContent.lrcArrayTime.count; i++) {

        // 下一句歌词

//        NSArray *timeArray=[self.lrcContent.timerArray[i] componentsSeparatedByString:@":"];
//        NSArray *timeArray=[self.lyriContent.lrcArrayTime[i] componentsSeparatedByString:@""];
        CGFloat lrcTime = [self.lyriContent.lrcArrayTime[i] floatValue];
//        float lrcTime=[timeArray[0] intValue]*60+[timeArray[1] floatValue];
        if(currentTime>=lrcTime){
            _currentRow=i;
            if (_currentRow < self.lyriContent.lrcArrayEachLrcProgress.count) {
                CGFloat percent = currentTime - lrcTime;
                LyricsModel *model = self.lyriContent.lrcArrayEachLrcProgress[_currentRow];
                CGFloat totalTime = model.eachLrcTime;
                model.progress = percent/totalTime;
            }
        }else{
            break;
        }
    }
    
    [self.lrcTable reloadData];
    [self.lrcTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
//    NSInteger next = _currentRow + 1;
//    if (next < self.lyriContent.lrcArrayTime.count) {
//        CGFloat nextLrcTime = [self.lyriContent.lrcArrayTime[next] floatValue];
//        CGFloat lrcTime1 = [self.lyriContent.lrcArrayTime[_currentRow] floatValue];
//        CGFloat totalTime = nextLrcTime - lrcTime1; // 当前歌词总时间
//        NSLog(@"当前行 = %ld  歌词时间 ==== %.f",_currentRow,totalTime);
//        _currentTotalTimeArr = @[@(0),@(totalTime/2.0),@(totalTime)];
//    }
    
    

}

//实现高斯模糊
-(UIImage *)getBlurredImage:(UIImage *)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage=[CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter=[CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@5.0f forKey:@"inputRadius"];
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef ref=[context createCGImage:result fromRect:[result extent]];
    return [UIImage imageWithCGImage:ref];
}
@end
