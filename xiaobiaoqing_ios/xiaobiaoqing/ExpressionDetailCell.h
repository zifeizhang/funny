//
//  ExpressionDetailCell.h
//  funnyji
//
//  Created by zhangzifei on 16/1/14.
//  Copyright © 2016年 com.gohoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressionDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

-(void)imageView:(int64_t)expression_id imageId:(int64_t)image_id url:(NSString*)image_url;

@end
