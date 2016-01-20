//
//  jokeCollectCell.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/11/18.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class jokeCollectCell;
@protocol jokeCollectCellDelegate <NSObject>

-(void)cancelCollectBtn:(jokeCollectCell*)cell;
-(void)shareCollectBtn:(jokeCollectCell*)cell;
@end

@interface jokeCollectCell : UITableViewCell

@property(nonatomic, weak)id<jokeCollectCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
