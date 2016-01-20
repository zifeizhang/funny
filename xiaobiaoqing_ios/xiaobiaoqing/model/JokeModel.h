//
//  JokeModel.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JokeModel : NSObject

@property(nonatomic,retain)NSString *joke_content;
@property(nonatomic,assign)int64_t joke_id;
@property(nonatomic,assign)int64_t time_since1970;

@end
