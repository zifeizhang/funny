//
//  PictureEntity.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PictureEntity : NSManagedObject

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *d_gif_image_url;
@property(nonatomic,retain)NSNumber *d_gif_image_id;
@property(nonatomic,retain)NSNumber *time_since1970;
@property(nonatomic,retain)NSString *first_icon_url;
@end
