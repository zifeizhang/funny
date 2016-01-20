//
//  JokeViewController.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/20.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "JokeViewController.h"
#import "JokeModel.h"
#import "JokeCell.h"
#import "NSString+SelfSize.h"
#import "JokeEntity.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "JokeCollectEntity.h"
#define url_str @"http://xiaobiaoqing.gohoc.com/index.php?r=list1/duanzi&offset=%ld&limit=10"

@interface JokeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,JokeCellDelegate>
{

    //加载更多
    NSInteger page;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    //判断是否有更多数据
    NSString *moreStr;
    UILabel *bottomLabel;
    
    NSInteger row;
    UIView *incView;
    
    NSDate *passTime;
}
@property(nonatomic,strong)UITableView *userTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;

//分享加载视图属性
@property(nonatomic,strong)UIView *panelView;
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;
@end

@implementation JokeViewController

-(id)init{

    if (self = [super init]) {
        _dataArr = [NSMutableArray array];
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
    
    self.userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49-64) style:UITableViewStylePlain];
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    [self.view addSubview:self.userTableView];
    self.userTableView.showsVerticalScrollIndicator = NO;
    [self.userTableView registerNib:[UINib nibWithNibName:@"JokeCell" bundle:nil] forCellReuseIdentifier:@"JokeCell"];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    footerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.userTableView.tableFooterView = footerView;
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
 
    //初始化分享View
    [self initWithShareSDKView];
    
    //初始化刷新（刷新数据库）
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(refreshButn)];
    [rightBtn setImage:[UIImage imageNamed:@"ico_repeat"]];
    [rightBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGrToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.userTableView addGestureRecognizer:longPressGr];
    
    [self initWithLoadingView];
}
-(void)viewWillAppear:(BOOL)animated{
    
    page = 0;
    [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
}
-(void)initWithLoadingView{
    incView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49)];
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

-(void)longPressGrToDo:(UILongPressGestureRecognizer*)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:self.userTableView];
        NSIndexPath *indexPath = [self.userTableView indexPathForRowAtPoint:point];
        if (indexPath == nil) {
            return;
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收藏" message:@"确定要收藏这个段子吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        row = indexPath.section;
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        JokeModel *model = _dataArr[row];
        if (![self dataFetchRequestDetail3:model]) {
            [self insertCoreData3:model];
        }
    }
}

-(void)initWithShareSDKView{
    
    //加载等待视图
    self.panelView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width)/2, (self.view.frame.size.height-self.loadingView.frame.size.height)/2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
}

-(void)refreshButn{
    
    //删除所有数据
    [self deleteData];
    page = 0;
    [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
}
- (void)addFooter
{
    __unsafe_unretained JokeViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.userTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        if ([refreshView isRefreshing]) {
            return ;
        }
        // 增加数据
        if ([moreStr isEqualToString:@"0"]) {
            
            [self endRefresh];
            bottomLabel.hidden = NO;
            [vc performSelector:@selector(doneWithView) withObject:nil afterDelay:2.0];
            
        }else{
            
            if (moreStr == nil) {
                [_dataArr removeAllObjects];
            }
            page = page + 10;
            [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
        }
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        NSLog(@"----开始进入刷新状态");
    };
    _footer = footer;
}
- (void)doneWithView
{
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
- (void)addHeader
{
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.userTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block

        if ([refreshView isRefreshing]) {
            return ;
        }
        page = 0;
        
        [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
        
        
        NSLog(@"----开始进入刷新状态");
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        
        NSLog(@"----刷新完毕");
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"----切换到：普通状态");
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"----切换到：松开即可刷新的状态");
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"----切换到：正在刷新状态");
                break;
            default:
                break;
        }
    };
    //[header beginRefreshing];
    _header = header;
}

-(void)getDataUrl:(NSString*)url{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSInteger pull = page;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        if (pull == 0) {
            if (_dataArr.count >0) {
                [_dataArr removeAllObjects];
            }
        }
        [self parsJSON:dic];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
        if (_dataArr.count > 0) {
            
            [_dataArr removeAllObjects];
        }
        [self dataFetchRequest];
        UIActivityIndicatorView *inc = (UIActivityIndicatorView*)[self.view viewWithTag:1000];
        [inc stopAnimating];
        [incView removeFromSuperview];
        [self endRefresh];
    }];
}

-(void)parsJSON:(NSDictionary*)dic{
    
    moreStr = dic[@"result"][@"more"];
    
    for ( NSDictionary *dic1 in dic[@"result"][@"data"]) {
        
        JokeModel *model = [[JokeModel alloc]init];
         model.joke_id = [dic1[@"joke_id"] longLongValue];
        model.joke_content = dic1[@"joke_content"];
        model.time_since1970 = [dic1[@"time_since1970"] longLongValue];
        [_dataArr addObject:model];
        
        //写入数据库
        if (![self dataFetchRequestDetail:model]) {
            
            [self insertCoreData:model];
        }
    }
    [self endRefresh];
    [self.userTableView reloadData];
    UIActivityIndicatorView *inc = (UIActivityIndicatorView*)[self.view viewWithTag:1000];
    [inc stopAnimating];
    [incView removeFromSuperview];
}

//插入数据库
-(void)insertCoreData:(JokeModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"JokeEntity" inManagedObjectContext:context];
    [entity setValue:[NSNumber numberWithLongLong:model.joke_id] forKey:@"joke_id"];
    [entity setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    [entity setValue:model.joke_content forKey:@"joke_content"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"不能保存:%@",[error localizedDescription]);
    }
}

//查询所有数据
-(void)dataFetchRequest{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"JokeEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    for (JokeEntity *info in fetchObjects) {
        
        JokeModel *model = [[JokeModel alloc]init];
        model.joke_id = [[info valueForKey:@"joke_id"] longLongValue];
        model.joke_content = [info valueForKey:@"joke_content"];
        model.time_since1970 = [[info valueForKey:@"time_since1970"] longLongValue];
        [_dataArr addObject:model];
    }
    [self.userTableView reloadData];
}
//条件查询每一条数据
-(BOOL)dataFetchRequestDetail:(JokeModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"JokeEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(joke_id = %@)",[NSNumber numberWithLongLong:model.joke_id]];
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    if (fetchObjects.count == 0) {
        return NO;
    }
    for (JokeEntity *info in fetchObjects) {
        
        [info setValue:[NSNumber numberWithLongLong:model.joke_id] forKey:@"joke_id"];
        [info setValue:model.joke_content forKey:@"joke_content"];
        [info setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    }
    
    if ([context save:&error]) {
        return YES;
    }else{
        
        return NO;
    }
}


//删除所有数据
-(void)deleteData{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"JokeEntity" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:desc];
    
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in datas) {
        
        [context deleteObject:obj];
    }
    if ([context save:&error]) {
        NSLog(@"删除成功");
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JokeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JokeCell"];
    cell.delegate = self;
    JokeModel *model = _dataArr[indexPath.section];
    
    [cell initWithDataModel:model];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    JokeModel *model = _dataArr[indexPath.section];

    CGSize size = [model.joke_content getSizeFromSelfWithWidth:_userTableView.frame.size.width - 40 andFont:16];
    
    return size.height + 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    self.userTableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];

    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.userTableView deselectRowAtIndexPath:indexPath animated:YES];
    JokeCell *cell = [self.userTableView cellForRowAtIndexPath:indexPath];
    JokeModel *model = _dataArr[indexPath.section];
    [self showShareActionSheet:cell text:model.joke_content];

}

#pragma mark - JokeCellDelegate
-(void)collectionButton:(JokeCell *)jokeCell{
 
    NSIndexPath *path = [_userTableView indexPathForCell:jokeCell];

    JokeModel *model = _dataArr[path.section];
    if (![self dataFetchRequestDetail3:model]) {
        [self insertCoreData3:model];
    }
}
-(void)collectionDesButton:(JokeCell *)jokeCell{

    NSIndexPath *path = [_userTableView indexPathForCell:jokeCell];
    
    JokeModel *model = _dataArr[path.section];
    if ([self dataFetchRequestDetail3:model]) {
        [self deleteFetchRequestDetail3:model];
    }
    
}
-(void)shareOutButton:(JokeCell *)jokeCell{

    NSIndexPath *path = [_userTableView indexPathForCell:jokeCell];
    JokeModel *model = _dataArr[path.section];
    [self showShareActionSheet:jokeCell text:model.joke_content];
}


//插入数据库
-(void)insertCoreData3:(JokeModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"JokeCollectEntity" inManagedObjectContext:context];
    [entity setValue:[NSNumber numberWithLongLong:model.joke_id] forKey:@"joke_id"];
    [entity setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    [entity setValue:model.joke_content forKey:@"joke_content"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"不能保存:%@",[error localizedDescription]);
    }
    
}

//条件删除一条数据
-(void)deleteFetchRequestDetail3:(JokeModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"JokeCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(joke_id = %@)",[NSNumber numberWithLongLong:model.joke_id]];
    NSError *error;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in datas) {
        
        [context deleteObject:obj];
    }
    if ([context save:&error]) {
        NSLog(@"删除成功");
    }
}

//条件查询每一条数据
-(BOOL)dataFetchRequestDetail3:(JokeModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"JokeCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(joke_id = %@)",[NSNumber numberWithLongLong:model.joke_id]];
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    if (fetchObjects.count == 0) {
        return NO;
    }
    for (JokeCollectEntity *info in fetchObjects) {
        
        [info setValue:[NSNumber numberWithLongLong:model.joke_id] forKey:@"joke_id"];
        [info setValue:model.joke_content forKey:@"joke_content"];
        [info setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    }
    
    if ([context save:&error]) {
        return YES;
    }else{
        
        return NO;
    }
}

//显示分享菜单
- (void)showShareActionSheet:(UIView *)view text:(NSString*)str
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:str
                                     images:nil
                                        url:nil
                                      title:@"来自Funny集"
                                       type:SSDKContentTypeText];

    [shareParams SSDKSetupCopyParamsByText:str
                                    images:nil
                                       url:nil
                                      type:SSDKContentTypeText];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithObjects:@(SSDKPlatformTypeCopy),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQQFriend),nil];
    
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
                                                                     items:activePlatforms
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                                   NSLog(@"分享成功!");
                                                                   break;
                                                               case SSDKResponseStateFail:
                                                                   NSLog(@"分享失败%@",error);
                                                                   break;
                                                               case SSDKResponseStateCancel:
                                                                   NSLog(@"分享已取消");
                                                                   break;
                                                               default:
                                                                   break;
                                                           }
                                                       }];
    
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeCopy)];
}


/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

-(void)dealloc{
    NSLog(@"--ExpressionViewController---dealloc");
    [_header free];
    [_footer free];
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
