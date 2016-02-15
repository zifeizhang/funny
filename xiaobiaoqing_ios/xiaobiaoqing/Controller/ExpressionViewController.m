//
//  EepressionViewController.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/20.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "ExpressionViewController.h"
#import "AppDelegate.h"
#import "ExpressionModel.h"
#import "ExpressionViewCell.h"
#import "ExpressionEntity.h"
#import "ExpressionDetailController.h"
#import "MJRefresh.h"
#import "NSString+SelfSize.h"
#define url_str  @"http://xiaobiaoqing.gohoc.com/index.php?r=list1/icon-box&offset=%ld&limit=18"
#define expression_url  @"http://xiaobiaoqing.gohoc.com/index.php?r=list1/icon-base1all&id=%lld"
#import "ZFProgressView.h"
#import "ExpressionDetailModel.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import "ExpressionDetailEntity.h"
@interface ExpressionViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *userTableView;
    UICollectionView *userCollectionView;
    //加载更多
    NSInteger page;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    //判断是否有更多数据
    NSString *moreStr;
    UILabel *bottomLabel;
    
    UIView *incView;
    NSArray *imageArr;
    
    float progress;
    
    ExpressionModel *globalModel;
    ExpressionViewCell *globalCell;
    
    NSMutableDictionary *queueDic ;
    NSOperationQueue *operaQueue;
    
}

@property(nonatomic , strong)NSMutableArray *dataSoureArr;

@property(nonatomic,copy)NSString *imagePath1;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,assign)NSInteger total;


@end

@implementation ExpressionViewController

-(id)init{

    if (self = [super init]) {
        queueDic = [[NSMutableDictionary alloc]init];
        operaQueue = [[NSOperationQueue alloc]init];
        _dataSoureArr = [NSMutableArray array];
        imageArr = [NSArray arrayWithObjects:@"ico_weixin",@"ico_qq",@"ico_sina", nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    userTableView.delegate = self;
    userTableView.dataSource = self;
    [userTableView registerNib:[UINib nibWithNibName:@"ExpressionViewCell" bundle:nil] forCellReuseIdentifier:@"ExpressionViewCell"];
    [self.view addSubview:userTableView];
    userTableView.rowHeight = 80;
    userTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    //
    bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64-49-30, self.view.frame.size.width, 30)];
    bottomLabel.text = @"当前没有更多数据";
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.hidden = YES;
    bottomLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomLabel];
    //
   
    moreStr = nil;
    // 集成刷新控件
    // 下拉刷新
    [self addHeader];
    // 上拉加载更多
    [self addFooter];
    
    //初始化刷新（刷新数据库）
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(refreshButn)];
    [rightBtn setImage:[UIImage imageNamed:@"ico_repeat"]];
    [rightBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //加载动画
    [self initWithLoadingView];
    
    
    //初始化登录按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(loginButn)];
    [leftBtn setImage:[UIImage imageNamed:@"login"]];
    [leftBtn setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    _total = 0;
    progress = 0;

}
-(void)viewWillAppear:(BOOL)animated{

    page = 0;
    [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
}
-(void)loginButn{

    if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo] || [ShareSDK hasAuthorized:SSDKPlatformTypeQQ] || [ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
        UserViewController *vc = [[UserViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else{
    
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        if ([[userInfo objectForKey:@"isLogin"] isEqualToString:@"1"]) {
            UserViewController *vc = [[UserViewController alloc]init];
            vc.icon = [userInfo objectForKey:@"iconP"];
            vc.phoneNum = [userInfo objectForKey:@"phoneNum"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }else{
        
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
    }
    
}

-(void)initWithLoadingView{
    
    incView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49-64)];
    incView.backgroundColor = [UIColor whiteColor];
    incView.alpha = 0.5;
    [self.view addSubview:incView];
    
    UIActivityIndicatorView *inc = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    inc.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.1);
    inc.tag = 1000;
    inc.color = [UIColor redColor];
    [incView addSubview:inc];
    [inc startAnimating];
}

-(void)refreshButn{
    
    //删除所有数据
    [self deleteData];
    page = 0;
    [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
}
- (void)addFooter{
    __unsafe_unretained ExpressionViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = userTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        if ([refreshView isRefreshing]) {
            return ;
        }
        // 增加数据
        if ([moreStr isEqualToString:@"0"]) {
            [self endRefresh];
            bottomLabel.hidden = NO;
            
            [vc performSelector:@selector(doneWithView) withObject:nil afterDelay:1.0];
            
        }else{
            
            page = page + 18;
            [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
        }
         // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        ZFLog(@"----开始进入刷新状态");
    };
    
    _footer = footer;
    
}
- (void)doneWithView{
    
    bottomLabel.hidden = YES;
}

-(void)endRefresh{

    dispatch_async(dispatch_get_main_queue(), ^{
       
        if ([_header isRefreshing]) {
            [_header endRefreshing];
        }
        if ([_footer isRefreshing]) {
            [_footer endRefreshing];
        }
    });
}

- (void)addHeader{
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = userTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        if ([refreshView isRefreshing]) {
            return ;
        }
        
        page = 0;
        [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
        
        ZFLog(@"----开始进入刷新状态");
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        
        ZFLog(@"----刷新完毕");
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                ZFLog(@"----切换到：普通状态");
                break;
                
            case MJRefreshStatePulling:
                ZFLog(@"----切换到：松开即可刷新的状态");
                break;
                
            case MJRefreshStateRefreshing:
                ZFLog(@"----切换到：正在刷新状态");
                break;
            default:
                break;
        }
    };
    //[header beginRefreshing];
    _header = header;
}

-(void)getDataUrl:(NSString*)Url{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSInteger pull = page;

    [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        if (pull == 0) {
            
            if (_dataSoureArr.count > 0) {
                
                [_dataSoureArr removeAllObjects];
            }
        }
        
        [self parsJSON:dic];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ZFLog(@"请求失败");
        if (_dataSoureArr.count > 0) {
            
            [_dataSoureArr removeAllObjects];
        }
        [self dataFetchRequest];
        UIActivityIndicatorView *inc = (UIActivityIndicatorView*)[self.view viewWithTag:1000];
        [inc stopAnimating];
        [incView removeFromSuperview];
        
        [self endRefresh];
    }];
    
}

//解析数据
-(void)parsJSON:(NSDictionary*)dic{
    
    moreStr = dic[@"result"][@"more"];
    
    for (NSDictionary *dic1 in dic[@"result"][@"data"]) {
        
        ExpressionModel *model = [[ExpressionModel alloc]init];
        
        model.expression_id = [dic1[@"expression_id"] longLongValue];
        
        model = [self dataFetchRequestDetails:model];
        
        model.name = dic1[@"name"];
        model.cover_image_url = dic1[@"cover_image_url"];
        model.time_since1970 = [dic1[@"time_since1970"] longLongValue];
        model.author = dic1[@"author"];
        model.weixin = dic1[@"weixin"];
        
        
        
        //写入数据库
        BOOL isData = [self dataFetchRequestDetail:model];
        if (!isData) {
            
            [self insertCoreData:model];
            
        }
        
        [_dataSoureArr addObject:model];
        
     }
    [self endRefresh];
    [userTableView reloadData];
    UIActivityIndicatorView *inc = (UIActivityIndicatorView*)[self.view viewWithTag:1000];
    [inc stopAnimating];
    [incView removeFromSuperview];
}
//插入数据
-(void)insertCoreData:(ExpressionModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    
    NSManagedObject *expressionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"ExpressionEntity" inManagedObjectContext:context];
    
    [expressionEntity setValue:[NSNumber numberWithLongLong:model.expression_id]  forKey:@"expression_id"];
    [expressionEntity setValue:model.name forKey:@"name"];
    [expressionEntity setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    [expressionEntity setValue:model.cover_image_url forKey:@"cover_image_url"];
    [expressionEntity setValue:model.author forKey:@"author"];
    [expressionEntity setValue:model.weixin forKey:@"weixin"];
    [expressionEntity setValue:@(model.isDownload) forKey:@"isDownload"];
    [expressionEntity setValue:@(model.isCollect) forKey:@"isCollect"];
    
    NSError *error;
    
    if (![context save:&error]) {
        ZFLog(@"不能保存:%@",[error localizedDescription]);
    }
}
//查询全部数据
- (void)dataFetchRequest
{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"ExpressionEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:description];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (ExpressionEntity *info in fetchedObjects) {
        
        ExpressionModel *model = [[ExpressionModel alloc]init];
        model.expression_id = [[info valueForKey:@"expression_id"] longLongValue];
        model.name = [info valueForKey:@"name"];
        model.time_since1970 = [[info valueForKey:@"time_since1970"]longLongValue];
        model.cover_image_url = [info valueForKey:@"cover_image_url"];
        model.author = [info valueForKey:@"author"];
        model.weixin = [info valueForKey:@"weixin"];
        model.isDownload = [[info valueForKey:@"isDownload"] intValue];
        [_dataSoureArr addObject:model];
        
    }
    [userTableView reloadData];
}

//条件查询每一条数据
-(BOOL)dataFetchRequestDetail:(ExpressionModel*)model{

    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"ExpressionEntity" inManagedObjectContext:context];
    [request setEntity:description];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(expression_id = %@)",[NSNumber numberWithLongLong:model.expression_id]];
   
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    if (fetchedObjects.count == 0) {
        return NO;
    }
    //保存
    if ([context save:&error]) {
        //更新成功
        //NSLog(@"更新成功");
        return YES;
    }else{
    
        return NO;
    }

}
//条件查询每一条数据
-(ExpressionModel *)dataFetchRequestDetails:(ExpressionModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"ExpressionEntity" inManagedObjectContext:context];
    [request setEntity:description];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(expression_id = %@)",[NSNumber numberWithLongLong:model.expression_id]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    if (fetchedObjects.count == 0) {
        
    }else{
        for (ExpressionEntity *info in fetchedObjects) {
        
        model.expression_id = [info.expression_id longLongValue];
        model.name = info.name;
        model.time_since1970 = [info.time_since1970 longLongValue];
        model.cover_image_url = info.cover_image_url;
        model.author = info.author;
        model.weixin = info.weixin;
        model.isDownload = [info.isDownload intValue];
        model.isCollect = [info.isCollect intValue];
        }
    }
   
    return model;
}

//删除数据
-(void)deleteData{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"ExpressionEntity" inManagedObjectContext:context];
    NSFetchRequest *request =[[NSFetchRequest alloc]init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:description];
    NSError *error = nil;
    
    NSArray *datas = [context executeFetchRequest:request error:&error];
    
    
    for (NSManagedObject *obj in datas) {
        
        [context deleteObject:obj];
        
    }
    if ([context save:&error]) {
        
        ZFLog(@"删除成功");
    }
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSoureArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpressionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpressionViewCell"];
    ExpressionModel *model = _dataSoureArr[indexPath.row];
    [cell cellWithData:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [userTableView deselectRowAtIndexPath:indexPath animated:YES];
    ExpressionModel *model = _dataSoureArr[indexPath.row];
    ExpressionViewCell *cell = [userTableView cellForRowAtIndexPath:indexPath];
    
    if (model.isDownload == 1) {
        
        ExpressionDetailController *detailVC = [[ExpressionDetailController alloc]init];
        detailVC.model = model;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else{
        
        
        if (queueDic.count > 0) {
            
            NSBlockOperation *copyBlock = [queueDic objectForKey:[NSString stringWithFormat:@"%lld",model.expression_id]];
            
            if (copyBlock) {
                
                if (!copyBlock.cancelled) {
                    
                    [copyBlock cancel];
                    cell.progressView.hidden = YES;
                    [cell.btn setTitle:@"已暂停" forState:UIControlStateNormal];
                    _total = 0;
                    cell.selfModel.isDownload = 2;
                    
                    [self insertCoreData:cell.selfModel];
                    
                    NSIndexPath *indexPath = [userTableView indexPathForCell:cell];
                    [userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    if (queueDic != nil) {
                        [queueDic removeObjectForKey:[NSString stringWithFormat:@"%lld",model.expression_id]];
                    }
                    
                }
                
                return;
            }
        }
        cell.selfModel.isDownload = 3;
        [self insertCoreData:cell.selfModel];

        
        __block NSString *connectionKind = nil;
        [[AFNetworkReachabilityManager sharedManager]startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                {
                    connectionKind = @"当前没有网络连接\n请检查你的网络设置";
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    connectionKind = @"您现在使用的是2G/3G/4G网络\n可能会产生流量费用\n确定下载吗？";
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    connectionKind = @"当前使用的是WIFI网络\n确定下载吗？";
                }
                    break;
                default:
                    break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (status == AFNetworkReachabilityStatusNotReachable) {
                     UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"" message:connectionKind delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [view show];
                }else{
                    UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"" message:connectionKind delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    
                    [view show];
                    
                }
                
            });
            
        }];
        
        globalCell = cell;
        globalModel = model;
        
        }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        _imagePath1 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",globalModel.expression_id]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_imagePath1])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_imagePath1 withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
            
        }
        globalCell.progressView.hidden = NO;
        globalCell.btn.userInteractionEnabled = NO;
        
        
        [self getImageDataUrl:[NSString stringWithFormat:expression_url,globalModel.expression_id] tag:(int)globalModel.expression_id cell:globalCell];
        
        
    }

}

-(void)getImageDataUrl:(NSString*)Url tag:(NSInteger)tag cell:(ExpressionViewCell*)cell{
    
    
    int64_t gid = globalModel.expression_id;
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        [self parsJSON:dic tag:tag cell:cell Id:gid];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZFLog(@"请求失败");
    }];
}
//解析数据
-(void)parsJSON:(NSDictionary*)dic tag:(NSInteger)tag cell:(ExpressionViewCell*)cell Id:(int64_t)gid{
    
    dispatch_queue_t queue = dispatch_queue_create("tupianxiazai", nil);
    dispatch_async(queue, ^{
        
        __weak typeof  (self) weakSelf = self;
    
        NSBlockOperation *blo = [[NSBlockOperation alloc]init];
        
         __weak NSBlockOperation *blockBlo = blo;
        
        [blo addExecutionBlock:^{
            
            @synchronized(self) {
                _count = [dic[@"result"][@"count"] integerValue];
                for (NSDictionary *dic1 in dic[@"result"][@"data"]) {
                    
                    ExpressionDetailModel *model = [[ExpressionDetailModel alloc]init];
                    model.image_url = dic1[@"image_url"];
                    model.image_id = [dic1[@"image_id"] longLongValue];
                    model.name = dic1[@"name"];
                    model.time_since1970 = [dic1[@"time_since1970"] longLongValue];
                    model.expression_id = gid;
                    
                    //写入数据库
                    if (![self dataFetchRequestDetail_detail:model]) {
                        [self insertCoreData_detail:model];
                    }
                    
                    if (!blockBlo.isCancelled) {
                        [weakSelf downloadImage:model tag:tag cell:cell];
                    }
                }
            }

        }];
       
        [operaQueue setMaxConcurrentOperationCount:1];
        [queueDic  setObject:blo forKey:[NSString stringWithFormat:@"%lld",globalModel.expression_id]];
        [operaQueue addOperation:blo];
        
        });
    
}


-(void)downloadImage:(ExpressionDetailModel*)model tag:(NSInteger)tag cell:(ExpressionViewCell*)cell{
    
    @synchronized(self) {
        
        NSString *imagePath = [_imagePath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",model.image_id]];
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:imagePath]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.image_url]]];
            [data writeToFile:imagePath atomically:YES];
        }
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            _total++;
            progress = _total*1.0/_count;
            
            if (cell.selfModel.isDownload == 3 ) {
                cell.progressView.hidden = NO;
                [cell.progressView setProgress:progress animated:YES];
            }
            
            if (_total == _count) {
                
                _total = 0;
                progress = 0;
                [cell.progressView setProgress:progress animated:YES];
                cell.progressView.hidden = YES;
                cell.userInteractionEnabled = YES;
                cell.btn.userInteractionEnabled = NO;
                
                [cell.btn setTitleColor:[UIColor colorWithRed:144/255.0 green:146/255.0 blue:147/255.0 alpha:1] forState:UIControlStateNormal];
                cell.btn.layer.borderColor = [UIColor colorWithRed:144/255.0 green:146/255.0 blue:147/255.0 alpha:1].CGColor;
                [cell.btn setTitle:@"已下载" forState:UIControlStateNormal];
                
                cell.selfModel.isDownload = 1;
                [self insertCoreData:cell.selfModel];
                
                NSIndexPath *indexPath = [userTableView indexPathForCell:cell];
                [userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        });

    }
    
}

//========================================

//插入数据库
-(void)insertCoreData_detail:(ExpressionDetailModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"ExpressionDetailEntity" inManagedObjectContext:context];
    [entity setValue:[NSNumber numberWithLongLong:model.image_id] forKey:@"image_id"];
    [entity setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    [entity setValue:model.name forKey:@"name"];
    [entity setValue:model.image_url forKey:@"image_url"];
    [entity setValue:[NSNumber numberWithLongLong:model.expression_id] forKey:@"expression_id"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"不能保存:%@",[error localizedDescription]);
    }
}

//条件查询每一条数据
-(BOOL)dataFetchRequestDetail_detail:(ExpressionDetailModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"ExpressionDetailEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(image_id = %@)",[NSNumber numberWithLongLong:model.image_id]];
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    if (fetchObjects.count == 0) {
        return NO;
    }
    for (ExpressionDetailEntity *info in fetchObjects) {
        
        [info setValue:[NSNumber numberWithLongLong:model.image_id] forKey:@"image_id"];
        [info setValue:model.name forKey:@"name"];
        [info setValue:model.image_url forKey:@"image_url"];
        [info setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
        [info setValue:[NSNumber numberWithLongLong:model.expression_id] forKey:@"expression_id"];
    }
    
    if ([context save:&error]) {
        return YES;
    }else{
        
        return NO;
    }
}



-(void)dealloc{
    [_header free];
    [_footer free];
    [[AFNetworkReachabilityManager sharedManager]stopMonitoring];
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
