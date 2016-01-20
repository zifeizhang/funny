//
//  PackageCell.h
//  funnyji
//
//  Created by zhangzifei on 16/1/19.
//  Copyright © 2016年 com.gohoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *packageHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end
