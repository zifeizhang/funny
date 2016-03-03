//
//  AppCell.m
//  XMShare
//
//  Created by zhangzifei on 16/2/22.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import "AppCell.h"
#import "UIImageView+WebCache.h"
#import "AppModel.h"
@implementation AppCell

-(void)cellWithData:(AppModel *)model{

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://appface.gohoc.com/%@",model.icon]]placeholderImage:[UIImage imageNamed:@"hourglass"]];
    
    self.descriptionLabel.text = model.jianjie;
    
    if (![_appDic[model.name] isKindOfClass:[NSNull class]]) {
        self.titleLabel.text = _appDic[model.name];
    }else{
        
        self.titleLabel.text = model.name;
    }

}
- (void)awakeFromNib {
    // Initialization code
    self.descriptionLabel.numberOfLines = 0;
    _appDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Funny集",@"xiaobiaoqing",@"静音",@"jingyin",@"轻记录",@"qinjilu",@"luxsns",@"luxsns",@"彩色格子",@"caisegezi", nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
