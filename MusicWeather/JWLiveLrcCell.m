//
//  JWLiveLrcCell.m
//  jwlive
//
//  Created by shuangwuxu on 2019/6/17.
//  Copyright © 2019 Mr ZnLG. All rights reserved.
//

#import "JWLiveLrcCell.h"
#import "Masonry/Masonry.h"

@implementation JWLiveLrcCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = nil;
    
//    LXMLyricsLabel *lyricsLabel = [[LXMLyricsLabel alloc] initWithFrame:self.bounds];
////    lyricsLabel.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, self.bounds.size.height);
////    lyricsLabel.backgroundColor = [UIColor lightGrayColor];
//    lyricsLabel.textLabel.textColor = [UIColor whiteColor];
//    lyricsLabel.font = [UIFont systemFontOfSize:13];
////    lyricsLabel.text = @"向前跑！迎着冷眼和嘲笑";//@"knocking on heaven's door";
//    lyricsLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:lyricsLabel];
//    self.lyricLabel = lyricsLabel;

    
//    self.lrcLabel = [[UILabel alloc] init];
//    self.lrcLabel.layer.shadowOpacity = 0.8;
//    self.lrcLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.lrcLabel.layer.shadowOffset = CGSizeMake(0.5, 1.0);
//    self.lrcLabel.layer.shadowRadius= 0.8;
//
//    self.lrcLabel.textColor = [UIColor whiteColor];
//    self.lrcLabel.font = [UIFont systemFontOfSize:13.0f];
//    self.lrcLabel.numberOfLines = 0;
//    self.lrcLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:self.lrcLabel];
//    [self.lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 5, 10, 5));
//    }];
    
    JWRefreshLrcLabel *refreshLrcLabel = [[JWRefreshLrcLabel alloc] initWithFrame:self.bounds];
    refreshLrcLabel.textColor = [UIColor whiteColor];
    refreshLrcLabel.fillColor = [UIColor greenColor];
    refreshLrcLabel.font = [UIFont systemFontOfSize:13.0f];
    refreshLrcLabel.numberOfLines = 0;
    refreshLrcLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshLrcLabel = refreshLrcLabel;
    [self.contentView addSubview:refreshLrcLabel];
    [refreshLrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.equalTo(self.contentView);
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.lyricLabel.frame = self.bounds;
}
@end
