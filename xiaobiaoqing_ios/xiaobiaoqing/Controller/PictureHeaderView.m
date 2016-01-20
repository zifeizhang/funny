//
//  PictureHeaderView.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/11/17.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "PictureHeaderView.h"

@implementation PictureHeaderView

- (void)awakeFromNib {
    // Initialization code
    
    self.remindLabel.text = @"点击查看动态图，长按可选收藏、分享";
    self.remindLabel.backgroundColor = [UIColor whiteColor];
    self.remindLabel.textColor = [UIColor colorWithRed:167/255.0 green:168/255.0 blue:169/255.0 alpha:1];
    
}

@end
