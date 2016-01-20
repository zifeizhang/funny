//
//  ExpressionHeaderView.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/11/11.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "ExpressionHeaderView.h"

@implementation ExpressionHeaderView

-(void)initWithHeader:(ExpressionModel *)model{

    [self.headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.cover_image_url]]placeholderImage:[UIImage imageNamed:@"hourglass"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.authorLabel.text = [NSString stringWithFormat:@"%@",model.author];
    
    if ([model.weixin isEqualToString:@""] || model.weixin == nil) {
        self.weixinBtn.hidden = YES;
        self.weixinLab.hidden = YES;
        self.weixinhaoLab.hidden = YES;
    }
    
    self.weixinLab.text = [NSString stringWithFormat:@"%@",model.weixin];
    [self.weixinBtn addTarget:self action:@selector(copyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectBtn addTarget:self action:@selector(collectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (model.isCollect == 1) {
        [self.collectBtn setImage:[UIImage imageNamed:@"ico_love_on"] forState:UIControlStateNormal];
        self.collectBtn.selected = NO;
    
    }else{
        
        [self.collectBtn setImage:[UIImage imageNamed:@"ico_love"] forState:UIControlStateNormal];
        self.collectBtn.selected = YES;
    }
}
-(void)copyClick:(UIButton*)btn{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.weixinLab.text;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}
- (void)awakeFromNib {
    // Initialization code
    _remindLabel.text = @"点击表情，可以分享；长按表情，可以收藏";
    _remindLabel.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    _remindLabel.textColor = [UIColor colorWithRed:144/255.0 green:146/255.0 blue:147/255.0 alpha:1];
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)collectButton:(UIButton*)sender {
    
    if (sender.selected == NO) {
        
        if (_delegate&&[_delegate respondsToSelector:@selector(packageCollectDesBtn)]) {
            
            [sender setImage:[UIImage imageNamed:@"ico_love"] forState:UIControlStateNormal];
            [_delegate packageCollectDesBtn];
        }
    }else{
        
        if (_delegate&&[_delegate respondsToSelector:@selector(packageCollectBtn)]) {
            
            [sender setImage:[UIImage imageNamed:@"ico_love_on"] forState:UIControlStateNormal];
            [_delegate packageCollectBtn];
        }
    }
    
    sender.selected = !sender.selected;
}

@end
