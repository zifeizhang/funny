//
//  ExpressionModel.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/20.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressionModel : NSObject

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *cover_image_url;
@property(nonatomic,assign)int64_t expression_id;
@property(nonatomic,assign)int64_t time_since1970;
@property(nonatomic,retain)NSString *author;
@property(nonatomic,retain)NSString *weixin;
@property(nonatomic,assign)int isDownload;
@property(nonatomic,assign)int isCollect;
@end
