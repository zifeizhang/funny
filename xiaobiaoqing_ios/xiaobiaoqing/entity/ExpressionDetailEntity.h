//
//  ExpressionDetailEntity.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ExpressionDetailEntity : NSManagedObject

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *image_url;
@property(nonatomic,retain)NSNumber *image_id;
@property(nonatomic,retain)NSNumber *time_since1970;
@property (nonatomic, retain) NSNumber * expression_id;

@end
