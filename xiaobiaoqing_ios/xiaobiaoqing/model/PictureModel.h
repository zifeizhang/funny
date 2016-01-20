//
//  PictureModel.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *d_gif_image_url;
@property(nonatomic,assign)int64_t d_gif_image_id;
@property(nonatomic,assign)int64_t time_since1970;
@property(nonatomic,retain)NSString *first_icon_url;
@end
