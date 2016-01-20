//
//  ExpressionDetailModel.h
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/29.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressionDetailModel : NSObject

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *image_url;
@property(nonatomic,assign)int64_t image_id;
@property(nonatomic,assign)int64_t time_since1970;

@property(nonatomic,assign)int64_t expression_id;
@end
