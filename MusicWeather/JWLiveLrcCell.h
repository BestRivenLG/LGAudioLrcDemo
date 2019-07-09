//
//  JWLiveLrcCell.h
//  jwlive
//
//  Created by shuangwuxu on 2019/6/17.
//  Copyright © 2019 Mr ZnLG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXMLyricsLabel.h"
#import "JWRefreshLrcLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JWLiveLrcCell : UITableViewCell
@property(nonatomic,strong)UILabel *lrcLabel;
@property(nonatomic,strong)LXMLyricsLabel *lyricLabel;
@property(nonatomic,strong)JWRefreshLrcLabel *refreshLrcLabel;

@end

NS_ASSUME_NONNULL_END
