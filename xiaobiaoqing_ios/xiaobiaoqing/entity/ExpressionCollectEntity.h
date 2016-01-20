//
//  ExpressionCollectEntity.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/11/4.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ExpressionCollectEntity : NSManagedObject

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *image_url;
@property(nonatomic,retain)NSNumber *image_id;
@property(nonatomic,retain)NSNumber *time_since1970;

@end
