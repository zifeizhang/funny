//
//  JokeCell.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"

@class JokeCell;
@protocol JokeCellDelegate <NSObject>

-(void)collectionButton:(JokeCell*)jokeCell;
-(void)collectionDesButton:(JokeCell*)jokeCell;
-(void)shareOutButton:(JokeCell*)jokeCell;
@end

@interface JokeCell : UITableViewCell

@property(nonatomic, weak)id<JokeCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

-(void)initWithDataModel:(JokeModel*)model;

@end
