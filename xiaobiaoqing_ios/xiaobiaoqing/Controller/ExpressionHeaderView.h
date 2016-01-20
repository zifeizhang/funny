//
//  ExpressionHeaderView.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/11/11.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressionModel.h"

@protocol ExpressionHeaderViewDelegate <NSObject>

-(void)packageCollectBtn;
-(void)packageCollectDesBtn;
@end

@interface ExpressionHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (weak, nonatomic) IBOutlet UILabel *weixinLab;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;

@property (weak, nonatomic) IBOutlet UILabel *weixinhaoLab;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property(nonatomic,weak)id<ExpressionHeaderViewDelegate>delegate;

-(void)initWithHeader:(ExpressionModel*)model;

@end
