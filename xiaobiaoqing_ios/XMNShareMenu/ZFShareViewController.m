//
//  ZFShareViewController.m
//  XMShare
//
//  Created by zhangzifei on 16/2/22.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import "ZFShareViewController.h"
#import "AFHTTPRequestOperationManager.h"

#import "AppModel.h"
#import "AppCell.h"
#import "XMNShareMenu.h"
#define APP_FACE_URL @"http://appface.gohoc.com/app/all"
@interface ZFShareViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *userTableView;
}
@property(nonatomic , strong)NSMutableArray *dataSoureArr;
@property(nonatomic,strong)NSDictionary *appDic;
@end

@implementation ZFShareViewController
-(id)init{
    
    if (self = [super init]) {
        _dataSoureArr = [NSMutableArray array];
        _appDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Funny集",@"xiaobiaoqing",@"静音",@"jingyin",@"轻记录",@"qinjilu",@"luxsns",@"luxsns",@"彩色格子",@"caisegezi", nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"应用推荐";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.translucent = NO;
    
    userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    userTableView.delegate = self;
    userTableView.dataSource = self;
    [self.view addSubview:userTableView];
    userTableView.rowHeight = 80;
    userTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    [self.view addSubview:userTableView];
    [userTableView registerNib:[UINib nibWithNibName:@"AppCell" bundle:nil] forCellReuseIdentifier:@"AppCell"];
    [self getDataUrl:APP_FACE_URL];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    [btn setImage:[UIImage imageNamed:@"ico_back"]];
    [btn setTitle:@"返回"];
    [btn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btn;
    
    
}
-(void)backClick{

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)getDataUrl:(NSString*)Url{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在加载"];

    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[dic[@"status"] stringValue] isEqualToString:@"200"]) {
                [self parsJSON:dic];
        }else{
        
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络错误" message:@"请检查你的网络是否连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
        [SVProgressHUD dismiss];
        
    }];
    
}
//解析数据
-(void)parsJSON:(NSDictionary*)dic{
    
    
    for (NSDictionary *dic1 in dic[@"data"]) {
        AppModel *model = [[AppModel alloc]init];
        
        model.name = dic1[@"name"];
        model.icon = dic1[@"icon"];
        model.jianjie = dic1[@"jianjie"];
//        NSLog(@"name ===== %@",model.name);
//        NSLog(@"icon ===== %@",dic1[@"icon"]);
//        NSLog(@"ioslink ===== %@",dic1[@"jianjie"]);
        [_dataSoureArr addObject:model];
    }
    [userTableView reloadData];
    
    if (_dataSoureArr.count == 0) {
        
        userTableView.hidden = YES;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, (self.view.frame.size.height-30)/2, self.view.frame.size.width-20, 30)];
        label.text = @"更多新应用正在开发中，请稍后";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
    }
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSoureArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell"];
    AppModel *model = _dataSoureArr[indexPath.row];
    
    [cell cellWithData:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [userTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppModel *model = _dataSoureArr[indexPath.row];
    
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 21, headerView.frame.size.width-32, 15)];
    label.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0];;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    XMNShareView *shareView = [[XMNShareView alloc] init];
    
    if (![_appDic[model.name] isKindOfClass:[NSNull class]]) {
    
        shareView.shareTitle = NSLocalizedString(_appDic[model.name], nil);
    }else{
        
        shareView.shareTitle = NSLocalizedString(model.name, nil);
    }
    
    if ([model.name isEqualToString:@"caisegezi"]) {
       
        NSArray *array = [model.jianjie componentsSeparatedByString:@"4、"];
        
        shareView.shareText = NSLocalizedString(array[0], nil);
    }else{
    
        shareView.shareText = NSLocalizedString(model.jianjie, nil);
    }
    
    
    
    shareView.shareUrl = [NSString stringWithFormat:@"http://appface.gohoc.com/app/%@",model.name];
    
    //设置头部View 如果不设置则不显示头部
    shareView.headerView = headerView;
    
    [shareView setSelectedBlock:^(NSUInteger tag, NSString *title) {
        NSLog(@"\ntag :%lu  \ntitle :%@",(unsigned long)tag,title);
        
    }];
    
    //计算高度 根据第一行显示的数量和总数,可以确定显示一行还是两行,最多显示2行
    [shareView setupShareViewWithItems:shareAry];
    
    [shareView showUseAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
