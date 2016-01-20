//
//  jokeCollectCell.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/11/18.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "jokeCollectCell.h"

@implementation jokeCollectCell




- (IBAction)cancelCollectButton:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelCollectBtn:)]) {
        
        [_delegate cancelCollectBtn:self];
    }
}

- (IBAction)shareCollectButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(shareCollectBtn:)]) {
        [_delegate shareCollectBtn:self];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
