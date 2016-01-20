//
//  ExpressionViewCell.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/28.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZFProgressView.h"

@class ExpressionModel;

@interface ExpressionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
 
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (strong, nonatomic) UIButton *btn;

@property(nonatomic,copy)NSString *imagePath1;
@property (strong,nonatomic)ExpressionModel *selfModel;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,assign)NSInteger total;
@property(nonatomic,strong)ZFProgressView *progressView;


-(ExpressionViewCell*)cellWithData:(ExpressionModel*)model;

@end
