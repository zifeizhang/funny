//
//  PictureCollectEntity.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/11/4.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PictureCollectEntity : NSManagedObject
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *d_gif_image_url;
@property(nonatomic,retain)NSNumber *d_gif_image_id;
@property(nonatomic,retain)NSNumber *time_since1970;
@property(nonatomic,retain)NSString *first_icon_url;
@end
