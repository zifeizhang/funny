//
//  JokeCell.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "JokeCell.h"

@implementation JokeCell


-(void)initWithDataModel:(JokeModel*)model{

    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.joke_content];
}

- (IBAction)collectionButton:(UIButton*)sender {
    
    if (sender.selected == YES) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(collectionDesButton:)]) {
            [sender setImage:[UIImage imageNamed:@"ico_love"] forState:UIControlStateNormal];
            [_delegate collectionDesButton:self];
        }
    }else{
        
        if (_delegate && [_delegate respondsToSelector:@selector(collectionButton:)]) {
            [sender setImage:[UIImage imageNamed:@"ico_love_on"] forState:UIControlStateSelected];
            [_delegate collectionButton:self];
        }
    }
    
    sender.selected = !sender.selected;
    
}


- (IBAction)shareButton:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(shareOutButton:)]) {
        [_delegate shareOutButton:self];
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
