//
//  ZFshareView.m
//  XMShare
//
//  Created by zhangzifei on 16/2/22.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import "ZFshareView.h"
#import "XMNShareMenu.h"
@interface ZFshareView ()

@property (nonatomic, strong) XMShareView *shareView;
@end

@implementation ZFshareView

-(void)clickCenterShare:(UIView *)view title:(NSString *)shareTitle text:(NSString *)shareText url:(NSString *)shareUrl{

    if(!self.shareView){
        
        self.shareView = [[XMShareView alloc] initWithFrame:view.bounds];
        
        self.shareView.alpha = 0.0;
        
        self.shareView.shareTitle = NSLocalizedString(shareTitle, nil);
        
        self.shareView.shareText = NSLocalizedString(shareText, nil);
        
        self.shareView.shareUrl = shareUrl;
        
        [view addSubview:self.shareView];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.alpha = 1.0;
        }];
        
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.alpha = 1.0;
        }];
        
    }

}
-(void)clickBottomShare:(UIView*)view title:(NSString*)shareTitle text:(NSString*)shareText url:(NSString*)shareUrl{

    //分享媒介数据源
    NSArray *shareAry = @[
                          //                                                    @{kXMNShareImage:@"more_chat",
                          //                                                      kXMNShareHighlightImage:@"more_chat_highlighted",
                          //                                                      kXMNShareTitle:@"私信和群"},
                          @{kXMNShareImage:@"more_weixin",
                            kXMNShareHighlightImage:@"more_weixin_highlighted",
                            kXMNShareTitle:@"微信好友"},
                          @{kXMNShareImage:@"more_circlefriends",
                            kXMNShareHighlightImage:@"more_circlefriends_highlighted",
                            kXMNShareTitle:@"朋友圈"},
                          //                                                    @{kXMNShareImage:@"more_icon_zhifubao",
                          //                                                      kXMNShareHighlightImage:@"more_icon_zhifubao_highlighted",
                          //                                                      kXMNShareTitle:@"支付宝好友"},
                          //                                                    @{kXMNShareImage:@"more_icon_zhifubao_friend",
                          //                                                      kXMNShareHighlightImage:@"more_icon_zhifubao_friend_highlighted",
                          //                                                      kXMNShareTitle:@"生活圈"},
                          @{kXMNShareImage:@"more_icon_qq",
                            kXMNShareHighlightImage:@"more_icon_qq_highlighted",
                            kXMNShareTitle:@"QQ"},
                          @{kXMNShareImage:@"more_icon_qzone",
                            kXMNShareHighlightImage:@"more_icon_qzone_highlighted",
                            kXMNShareTitle:@"QQ空间"},
                          @{kXMNShareImage:@"more_weibo",
                            kXMNShareHighlightImage:@"more_weibo_highlighted",
                            kXMNShareTitle:@"微博"},
                          //                          ,
                          //                          @{kXMNShareImage:@"more_mms",
                          //                            kXMNShareHighlightImage:@"more_mms_highlighted",
                          //                            kXMNShareTitle:@"短信"},
                          //                          @{kXMNShareImage:@"more_email",
                          //                            kXMNShareHighlightImage:@"more_email_highlighted",
                          //                            kXMNShareTitle:@"邮件分享"}
                          //                                                    ,
                          //                                                    @{kXMNShareImage:@"more_icon_cardbackground",
                          //                                                      kXMNShareHighlightImage:@"more_icon_cardbackground_highlighted",
                          //                                                      kXMNShareTitle:@"设卡片背景"},
                          //                                                    @{kXMNShareImage:@"more_icon_collection",
                          //                                                      kXMNShareTitle:@"收藏"},
                          //                                                    @{kXMNShareImage:@"more_icon_topline",
                          //                                                      kXMNShareTitle:@"帮上头条"},
                          //                                                    @{kXMNShareImage:@"more_icon_link",
                          //                                                      kXMNShareTitle:@"复制链接"},
                          //                                                    @{kXMNShareImage:@"more_icon_report",
                          //                                                      kXMNShareTitle:@"举报"},
                          //                                                    @{kXMNShareImage:@"more_icon_back",
                          //                                                      kXMNShareTitle:@"返回首页"}
                          ];
    
    //自定义头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 36)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 21, headerView.frame.size.width-32, 15)];
    label.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0];;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    XMNShareView *shareView = [[XMNShareView alloc] init];
    
    shareView.shareTitle = NSLocalizedString(shareTitle, nil);
    
    shareView.shareText = NSLocalizedString(shareText, nil);
    
    shareView.shareUrl = shareUrl;
    
    //设置头部View 如果不设置则不显示头部
    shareView.headerView = headerView;
    
    [shareView setSelectedBlock:^(NSUInteger tag, NSString *title) {
        NSLog(@"\ntag :%lu  \ntitle :%@",(unsigned long)tag,title);
        
    }];
    
    //计算高度 根据第一行显示的数量和总数,可以确定显示一行还是两行,最多显示2行
    [shareView setupShareViewWithItems:shareAry];
    
    [shareView showUseAnimated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
