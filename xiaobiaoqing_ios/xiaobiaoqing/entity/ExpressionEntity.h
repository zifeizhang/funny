//
//  ExpressionEntity.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/20.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ExpressionEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * expression_id;
@property (nonatomic, retain) NSNumber * time_since1970;
@property (nonatomic, retain) NSString * cover_image_url;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * weixin;
@property (nonatomic, assign) NSNumber * isDownload;
@property (nonatomic, assign) NSNumber * isCollect;

@end
