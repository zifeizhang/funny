//
//  JokeEntity.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JokeEntity : NSManagedObject

@property(nonatomic,retain)NSNumber *joke_id;

@property(nonatomic,retain)NSNumber *time_since1970;

@property(nonatomic,retain)NSString *joke_content;

@end
