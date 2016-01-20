//
//  PictureViewController.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/20.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureModel.h"
#import "PictureEntity.h"
#import "CollectionViewCell.h"
#import "AppDelegate.h"
#import "PictureHeaderView.h"

#import "PictureCollectEntity.h"
#define kMainWidth  ([UIScreen mainScreen].bounds.size.width - 30)/3
#define url_str @"http://xiaobiaoqing.gohoc.com/index.php?r=list1/icon-base&offset=%ld&limit=30"
#import "MJRefresh.h"

#import "ImageViewController.h"

@interface PictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate,UICollectionViewDelegateFlowLayout>
{

    NSInteger page;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSString *moreStr;
    UILabel *bottomLabel;
    NSInteger item;
    
    UIView *incView;
}
@property(nonatomic,strong)UICollectionView *userCollectionView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UIRefreshControl *refreshCtl;

//分享加载视图属性
@property(nonatomic,strong)UIView *panelView;
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;

@end

@implementation PictureViewController



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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(kMainWidth, kMainWidth);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.userCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) collectionViewLayout:layout];
    self.userCollectionView.delegate = self;
    self.userCollectionView.dataSource = self;
    [self.view addSubview:self.userCollectionView];
    self.userCollectionView.showsVerticalScrollIndicator = NO;
    
    
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PictureCell"];
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"PictureHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PictureHeaderView"];
    
   
    self.userCollectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.userCollectionView.alwaysBounceVertical = YES;
    
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
    // 3.集成刷新控件
    // 3.1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.userCollectionView;
    header.delegate = self;
    _header = header;
    
    // 3.2.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.userCollectionView;
    footer.delegate = self;
    _footer = footer;
    
    //初始化分享View
    [self initWithShareSDKView];
    
    //初始化刷新（刷新数据库）
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(refreshButn)];
    [rightBtn setImage:[UIImage imageNamed:@"ico_repeat"]];
    [rightBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGrToDo:)];
    longPressGr.minimumPressDuration = 0.5;
    [self.userCollectionView addGestureRecognizer:longPressGr];
    [self initWithLoadingView];
}

-(void)initWithLoadingView{
    incView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49)];
    incView.backgroundColor = [UIColor whiteColor];
    incView.alpha = 0.5;
    [self.view addSubview:incView];
    UIActivityIndicatorView *inc = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    inc.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.15);
    inc.tag = 1000;
    inc.color = [UIColor redColor];
    [incView addSubview:inc];
    [inc startAnimating];
}


-(void)longPressGrToDo:(UILongPressGestureRecognizer*)gesture{

    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:self.userCollectionView];
        NSIndexPath *indexPath = [self.userCollectionView indexPathForItemAtPoint:point];
        if (indexPath == nil) {
            return;
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定收藏或分享这张图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"收藏",@"分享", nil];
        item = indexPath.item;
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        PictureModel *model = _dataArr[item];
        if (![self dataFetchRequestDetail2:model]) {
            [self downloadImagemodel:model];
            [self insertCoreData2:model];
        }
    }else{
    
        if (buttonIndex == 0) {
            return;
        }
        PictureModel *model = _dataArr[item];
        UICollectionViewCell *cell = [self.userCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.d_gif_image_url]];
        [self showShareActionSheet:cell url:url model:model];
        
    }
}

//图片下载
-(void)downloadImagemodel:(PictureModel*)model{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.d_gif_image_url]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.gif",model.d_gif_image_id]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"正在加载"];
        
        dispatch_queue_t queue = dispatch_queue_create("tupianxiazai", nil);
        dispatch_async(queue, ^{
            
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.gif",model.d_gif_image_id]];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:imagePath atomically:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
    }else{
    
        return;
    }
}

-(void)viewWillAppear:(BOOL)animated{

    page = 0;
    [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
}
-(void)refreshButn{
    
    //删除所有数据
    [self deleteData];
    
    page = 0;
    [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
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

-(void)getDataUrl:(NSString*)url{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSInteger pull = page;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        if (pull == 0) {
            if (_dataArr.count > 0)  {
                [_dataArr removeAllObjects];
            }
        }
        [self parsJSON:dic];
       
//        ZFLog(@"dic===== %@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZFLog(@"请求失败");
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
- (void)endRefresh{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_footer isRefreshing]) {
            [_footer endRefreshing];
        }
        if ([_header isRefreshing]) {
            [_header endRefreshing];
        }
    });
    
}
-(void)parsJSON:(NSDictionary*)dic{
    
    moreStr = dic[@"result"][@"more"];
    for ( NSDictionary *dic1 in dic[@"result"][@"data"]) {
        
        PictureModel *model = [[PictureModel alloc]init];
        model.name = dic1[@"name"];
        model.d_gif_image_url = dic1[@"d_gif_image_url"];
        model.d_gif_image_id = [dic1[@"d_gif_image_id"] longLongValue];
        model.time_since1970 = [dic1[@"time_since1970"] longLongValue];
        model.first_icon_url = dic1[@"first_icon_url"];
        [_dataArr addObject:model];
        //写入数据库
        if (![self dataFetchRequestDetail:model]) {
            [self insertCoreData:model];
        }
    }
    
    [self endRefresh];
    [self.userCollectionView reloadData];
    UIActivityIndicatorView *inc = (UIActivityIndicatorView*)[self.view viewWithTag:1000];
    [inc stopAnimating];
    [incView removeFromSuperview];
}
//插入数据库
-(void)insertCoreData:(PictureModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"PictureEntity" inManagedObjectContext:context];
    [entity setValue:[NSNumber numberWithLongLong:model.d_gif_image_id] forKey:@"d_gif_image_id"];
    [entity setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    [entity setValue:model.name forKey:@"name"];
    [entity setValue:model.d_gif_image_url forKey:@"d_gif_image_url"];
    [entity setValue:model.first_icon_url forKey:@"first_icon_url"];
    
    NSError *error;
    if (![context save:&error]) {
        ZFLog(@"不能保存:%@",[error localizedDescription]);
    }
}
//查询所有数据
-(void)dataFetchRequest{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"PictureEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    for (PictureEntity *info in fetchObjects) {
        
        PictureModel *model = [[PictureModel alloc]init];
        model.d_gif_image_id = [[info valueForKey:@"d_gif_image_id"] longLongValue];
        model.name = [info valueForKey:@"name"];
        model.d_gif_image_url = [info valueForKey:@"d_gif_image_url"];
        model.first_icon_url = [info valueForKey:@"first_icon_url"];
        model.time_since1970 = [[info valueForKey:@"time_since1970"] longLongValue];
        [_dataArr addObject:model];
    }
    [self.userCollectionView reloadData];
}
//条件查询每一条数据
-(BOOL)dataFetchRequestDetail:(PictureModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"PictureEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(d_gif_image_id = %@)",[NSNumber numberWithLongLong:model.d_gif_image_id]];
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    if (fetchObjects.count == 0) {
        return NO;
    }
    for (PictureEntity *info in fetchObjects) {
        
        [info setValue:[NSNumber numberWithLongLong:model.d_gif_image_id] forKey:@"d_gif_image_id"];
        [info setValue:model.name forKey:@"name"];
        [info setValue:model.d_gif_image_url forKey:@"d_gif_image_url"];
        [info setValue:model.first_icon_url forKey:@"first_icon_url"];
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
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"PictureEntity" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:desc];
    
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in datas) {
        
        [context deleteObject:obj];
    }
    if ([context save:&error]) {
        ZFLog(@"删除成功");
    }
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"----开始进入刷新状态");
    
    if ([refreshView isRefreshing]) {
        return;
    }
    // 1.添加数据
    if (refreshView == _header)
    {
        page = 0;
        [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
        
    }else
    {
        if ([moreStr isEqualToString:@"0"])
        {
            [self endRefresh];
            bottomLabel.hidden = NO;
        }else
        {
            page = page+30;
            
            [self getDataUrl:[NSString stringWithFormat:url_str,(long)page]];
        }
    }
}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    PictureViewController *vc = self;
    if ([moreStr isEqualToString:@"0"]) {
        [vc performSelector:@selector(doneWithView) withObject:nil afterDelay:2.0];
    }
    NSLog(@"----刷新完毕");
}
- (void)doneWithView
{
    bottomLabel.hidden = YES;
}
#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
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
}
#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    CGSize size = {self.view.frame.size.width,45};
    return size;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    PictureHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PictureHeaderView" forIndexPath:indexPath];
    
    return header;
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dataArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    PictureModel *model = _dataArr[indexPath.item];
    
    [cell.PicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.first_icon_url]]placeholderImage:[UIImage imageNamed:@"hourglass"]];
    
    return cell;
}

//图片下载
-(void)downloadImage:(NSURL*)url model:(PictureModel*)model view:(UIView *)view{

        
        dispatch_queue_t queue = dispatch_queue_create("tupianxiazai", nil);
        dispatch_async(queue, ^{
            
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.gif",model.d_gif_image_id]];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:imagePath atomically:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self showShareActionSheet:view url:url model:model];
            });
        });
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kMainWidth, kMainWidth);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PictureModel *model = _dataArr[indexPath.row];
    ImageViewController *imageVC = [[ImageViewController alloc]init];
    imageVC.model = model;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:imageVC animated:NO completion:nil];
    
}
//插入数据库
-(void)insertCoreData2:(PictureModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"PictureCollectEntity" inManagedObjectContext:context];
    [entity setValue:[NSNumber numberWithLongLong:model.d_gif_image_id] forKey:@"d_gif_image_id"];
    [entity setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    [entity setValue:model.name forKey:@"name"];
    [entity setValue:model.d_gif_image_url forKey:@"d_gif_image_url"];
    [entity setValue:model.first_icon_url forKey:@"first_icon_url"];
    NSError *error;
    if (![context save:&error]) {
        ZFLog(@"不能保存:%@",[error localizedDescription]);
    }
    
}
//条件查询每一条数据
-(BOOL)dataFetchRequestDetail2:(PictureModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"PictureCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(d_gif_image_id = %@)",[NSNumber numberWithLongLong:model.d_gif_image_id]];
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    if (fetchObjects.count == 0) {
        return NO;
    }
    for (PictureCollectEntity *info in fetchObjects) {
        
        [info setValue:[NSNumber numberWithLongLong:model.d_gif_image_id] forKey:@"d_gif_image_id"];
        [info setValue:model.name forKey:@"name"];
        [info setValue:model.d_gif_image_url forKey:@"d_gif_image_url"];
        [info setValue:model.first_icon_url forKey:@"first_icon_url"];
        [info setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    }
    
    if ([context save:&error]) {
        return YES;
    }else{
        
        return NO;
    }
}


//显示分享菜单
- (void)showShareActionSheet:(UIView *)view url:(NSURL*)url model:(PictureModel*)model
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.gif",model.d_gif_image_id]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"正在加载"];
        [self downloadImage:url model:model view:view];
        return;
    }
    
    NSArray* imageArray = @[[UIImage imageWithData:data]];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"来自Funny集"
                                     images:imageArray
                                        url:nil
                                      title:@"来自Funny集"
                                       type:SSDKContentTypeAuto];
    
        [shareParams SSDKSetupWeChatParamsByText:@"来自Funny集"
                                           title:@"来自Funny集"
                                             url:nil
                                      thumbImage:nil
                                           image:nil
                                    musicFileURL:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:[NSData dataWithContentsOfFile:filePath]
                                            type:SSDKContentTypeImage
                              forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"来自Funny集"
                                               title:@"来自Funny集"
                                               image:filePath
                                                 url:url
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeAuto];
    [shareParams SSDKSetupQQParamsByText:@"来自Funny集"
                                   title:@"来自Funny集"
                                     url:nil
                              thumbImage:nil
                                   image:url
                                    type:SSDKContentTypeImage
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    [shareParams SSDKSetupCopyParamsByText:@"分享"
                                    images:imageArray
                                       url:nil
                                      type:SSDKContentTypeImage];
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithObjects:@(SSDKPlatformTypeCopy),@(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQQFriend),nil];
    
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
                                                                     items:activePlatforms
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                                   ZFLog(@"分享成功!");
                                                                   break;
                                                               case SSDKResponseStateFail:
                                                                   ZFLog(@"分享失败%@",error);
                                                                   break;
                                                               case SSDKResponseStateCancel:
                                                                   ZFLog(@"分享已取消");
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

    ZFLog(@"PictureViewController--dealloc---");
    [_header free];
    [_footer free];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


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
