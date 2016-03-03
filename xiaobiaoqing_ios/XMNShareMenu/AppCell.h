//
//  AppCell.h
//  XMShare
//
//  Created by zhangzifei on 16/2/22.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppModel;
@interface AppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,strong)NSDictionary *appDic;
-(void)cellWithData:(AppModel*)model;


@end
