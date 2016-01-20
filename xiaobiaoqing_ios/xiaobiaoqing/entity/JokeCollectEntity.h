//
//  JokeCollectEntity.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/11/4.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface JokeCollectEntity : NSManagedObject
@property(nonatomic,retain)NSString *joke_content;
@property(nonatomic,retain)NSNumber *joke_id;
@property(nonatomic,retain)NSNumber *time_since1970;

@end
