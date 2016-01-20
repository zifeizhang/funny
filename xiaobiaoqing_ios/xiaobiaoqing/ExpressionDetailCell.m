//
//  ExpressionDetailCell.m
//  funnyji
//
//  Created by zhangzifei on 16/1/14.
//  Copyright © 2016年 com.gohoc. All rights reserved.
//

#import "ExpressionDetailCell.h"

@implementation ExpressionDetailCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)imageView:(int64_t)expression_id imageId:(int64_t)image_id url:(NSString*)image_url{

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)expression_id]];
    NSString *filePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",image_id]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    UIImage *img = [UIImage imageWithData:data];
    
    if (img != nil) {
        
        self.contentImageView.image = img;
    }else{
        
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",image_url]]placeholderImage:[UIImage imageNamed:@"hourglass"]];
    }

}
@end
