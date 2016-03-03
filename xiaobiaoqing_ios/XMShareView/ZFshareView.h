//
//  ZFshareView.h
//  XMShare
//
//  Created by zhangzifei on 16/2/22.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFshareView : NSObject

/**
 *  中间弹出悬浮分享平台
 */
-(void)clickCenterShare:(UIView*)view title:(NSString*)shareTitle text:(NSString*)shareText url:(NSString*)shareUrl;

/**
 *  底部弹出分享平台
 */
-(void)clickBottomShare:(UIView*)view title:(NSString*)shareTitle text:(NSString*)shareText url:(NSString*)shareUrl;


@end
