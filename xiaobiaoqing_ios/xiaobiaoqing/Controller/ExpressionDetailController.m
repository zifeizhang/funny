//
//  ExpressionDetailController.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/29.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "ExpressionDetailController.h"
#import "ExpressionViewController.h"
#import "ExpressionDetailModel.h"
#import "ExpressionDetailEntity.h"
#import "AppDelegate.h"
#import "ExpressionHeaderView.h"
#import "ExpressionCollectEntity.h"
#import "ExpressionDetailCell.h"
#import "ExpressionEntity.h"
#define kMainWidth  ([UIScreen mainScreen].bounds.size.width - 40)/4

@interface ExpressionDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UICollectionViewDelegateFlowLayout,ExpressionHeaderViewDelegate>
{
    
    NSInteger item;
    
}


@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UICollectionView *userCollectionView;
//分享加载视图属性
@property(nonatomic,strong)UIView *panelView;
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;

@end

@implementation ExpressionDetailController

-(id)init{

    if (self = [super init]) {
        
        _dataArr = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.name;
    self.view.backgroundColor = [UIColor whiteColor];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.userCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)collectionViewLayout:layout];
    self.userCollectionView.delegate = self;
    self.userCollectionView.dataSource = self;
    [self.view addSubview:self.userCollectionView];
    
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"ExpressionDetailCell" bundle:nil] forCellWithReuseIdentifier:@"ExpressionDetailCell"];
    
    self.userCollectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.userCollectionView.alwaysBounceVertical = YES;
    self.userCollectionView.showsVerticalScrollIndicator = NO;
    
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"ExpressionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ExpressionHeaderView"];
    
    //初始化分享View
    [self initWithShareSDKView];
    
    //初始化返回按钮
    [self initWithBackButton];
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGrToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.userCollectionView addGestureRecognizer:longPressGr];
    
    //侧滑
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
}
//侧滑
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    if (self.navigationController.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{

    [self dataFetchRequest];
}
-(void)longPressGrToDo:(UILongPressGestureRecognizer*)gesture{

    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:self.userCollectionView];
        NSIndexPath *indexPath = [self.userCollectionView indexPathForItemAtPoint:point];
        if (indexPath == nil) {
            return;
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收藏" message:@"确定要收藏这张图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        item = indexPath.item;
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
         ExpressionDetailModel *model = _dataArr[item];
        if (![self dataFetchRequestDetail1:model]) {
            [self downloadImagemodel:model];
            [self insertCoreData1:model];
        }

    }
}
//图片下载
-(void)downloadImagemodel:(ExpressionDetailModel*)model{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.image_url]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",model.image_id]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if (data == nil) {
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"正在加载"];
        
        dispatch_queue_t queue = dispatch_queue_create("tupianxiazai", nil);
        dispatch_async(queue, ^{
            
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",model.image_id]];
            
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

-(void)initWithBackButton{

    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [btn setImage:[UIImage imageNamed:@"ico_back"]];
    [btn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btn;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
//查询所有数据
-(void)dataFetchRequest{

    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"ExpressionDetailEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(expression_id = %@)",[NSNumber numberWithLongLong:self.model.expression_id]];
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    for (ExpressionDetailEntity *info in fetchObjects) {
        
        ExpressionDetailModel *model = [[ExpressionDetailModel alloc]init];
        model.image_id = [[info valueForKey:@"image_id"] longLongValue];
        model.name = [info valueForKey:@"name"];
        model.image_url = [info valueForKey:@"image_url"];
        model.time_since1970 = [[info valueForKey:@"time_since1970"] longLongValue];
        model.expression_id = self.model.expression_id;
        [_dataArr addObject:model];
    }
    [self.userCollectionView reloadData];
}
//条件查询每一条数据
-(BOOL)dataFetchRequestDetail:(ExpressionDetailModel*)model{

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

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={self.view.frame.size.width,150};
    return size;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dataArr.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    ExpressionDetailModel *model = _dataArr[indexPath.row];
    
    ExpressionDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpressionDetailCell" forIndexPath:indexPath];
   
    [cell imageView:_model.expression_id imageId:model.image_id url:model.image_url];
        
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kMainWidth, kMainWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    
        
    ExpressionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ExpressionHeaderView" forIndexPath:indexPath];
        
    [header initWithHeader:self.model];
    header.delegate = self;
    
    return header;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpressionDetailModel *model = _dataArr[indexPath.row];
    
    UICollectionViewCell *cell = [self.userCollectionView cellForItemAtIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.image_url]];
    
    [self showShareActionSheet:cell model:model url:(NSURL*)url];
    
}

#pragma mark - ExpressionHeaderViewDelegate

-(void)packageCollectBtn{
    self.model.isCollect = 1;
    [self deleteDataFetchRequestCollectDetail:self.model];
    [self dataFetchCollectRequestDetail:self.model];
}



-(void)packageCollectDesBtn{

    self.model.isCollect = 0;
    [self deleteDataFetchRequestCollectDetail:self.model];
    [self dataFetchCollectRequestDetail:self.model];
}

//条件查询每一条数据
-(void)deleteDataFetchRequestCollectDetail:(ExpressionModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"ExpressionEntity" inManagedObjectContext:context];
    [request setEntity:description];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(expression_id = %@)",[NSNumber numberWithLongLong:model.expression_id]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];

    for (NSManagedObject *obj in fetchedObjects) {
        
        [context deleteObject:obj];
        
    }
    if ([context save:&error]) {
        
        ZFLog(@"删除成功");
    }

}

/**
 *     是否收藏表情包数据
 */
-(void)dataFetchCollectRequestDetail:(ExpressionModel*)model{
    
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

#pragma mark - 单张图片收藏
//插入数据库
-(void)insertCoreData1:(ExpressionDetailModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"ExpressionCollectEntity" inManagedObjectContext:context];
    [entity setValue:[NSNumber numberWithLongLong:model.image_id] forKey:@"image_id"];
    [entity setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    [entity setValue:model.name forKey:@"name"];
    [entity setValue:model.image_url forKey:@"image_url"];
    
    NSError *error;
    if (![context save:&error]) {
        ZFLog(@"不能保存:%@",[error localizedDescription]);
    }
}
//条件查询每一条数据
-(BOOL)dataFetchRequestDetail1:(ExpressionDetailModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"ExpressionCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(image_id = %@)",[NSNumber numberWithLongLong:model.image_id]];
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    if (fetchObjects.count == 0) {
        return NO;
    }
    for (ExpressionCollectEntity *info in fetchObjects) {
        
        [info setValue:[NSNumber numberWithLongLong:model.image_id] forKey:@"image_id"];
        [info setValue:model.name forKey:@"name"];
        [info setValue:model.image_url forKey:@"image_url"];
        [info setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    }
    
    if ([context save:&error]) {
        return YES;
    }else{
        
        return NO;
    }
}
//图片下载
-(void)downloadImage:(NSURL*)url model:(ExpressionDetailModel*)model view:(UIView *)view{
    
    
    dispatch_queue_t queue = dispatch_queue_create("tupianxiazai", nil);
    dispatch_async(queue, ^{
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)_model.expression_id]];
        NSString *filePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",model.image_id]];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        [data writeToFile:filePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self showShareActionSheet:view model:model url:url];
        });
    });
    
}


//显示分享菜单
- (void)showShareActionSheet:(UIView *)view model:(ExpressionDetailModel*)model url:(NSURL*)url
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)_model.expression_id]];
    NSString *filePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",model.image_id]];
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
    
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:nil
                                      title:@"分享标题"
                                       type:SSDKContentTypeAudio];
    
    [shareParams SSDKSetupWeChatParamsByText:@"分享内容"
                                       title:@"分享标题"
                                         url:nil
                                  thumbImage:nil
                                       image:nil
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:[NSData dataWithContentsOfFile:filePath]
                                        type:SSDKContentTypeImage
                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [shareParams SSDKSetupWeChatParamsByText:@"分享内容"
                                       title:@"分享标题"
                                         url:url
                                  thumbImage:[UIImage imageWithData:data]
                                       image:[UIImage imageWithData:data]
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeImage
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    [shareParams SSDKSetupQQParamsByText:@"分享内容"
                                   title:@"分享标题"
                                     url:nil
                              thumbImage:nil
                                   image:url
                                    type:SSDKContentTypeImage
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"分享内容"
                                               title:@"分享标题"
                                               image:[NSData dataWithContentsOfFile:filePath]
                                                 url:url
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeAuto];
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

- (void)dealloc
{
    ZFLog(@"ExpressionDetailController--dealloc---");
//    [_header free];
//    [_footer free];
    [_dataArr removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
/*
 -(void)initWithLoadingView{
 
 incView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
 incView.backgroundColor = [UIColor whiteColor];
 incView.alpha = 0.5;
 [self.view addSubview:incView];
 UIActivityIndicatorView *inc = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
 inc.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.4);
 inc.tag = 1000;
 inc.color = [UIColor redColor];
 [incView addSubview:inc];
 [inc startAnimating];
 
 }
 
 -(void)refreshButn{
 
 //删除所有数据
 [self deleteData];
 
 page = 0;
 [self getDataUrl:[NSString stringWithFormat:url_str,(long)page,self.model.expression_id]];
 }
 */

/*
 -(void)getDataUrl:(NSString*)Url{
 
 AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
 
 manager.responseSerializer=[AFHTTPResponseSerializer serializer];
 
 NSInteger pull = page;
 
 [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
 
 if (pull == 0) {
 if (_dataArr.count > 0) {
 
 [_dataArr removeAllObjects];
 }
 
 }
 [self parsJSON:dic];
 //        ZFLog(@"dic === %@",dic);
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
 
 //解析数据
 -(void)parsJSON:(NSDictionary*)dic{
 
 moreStr = dic[@"result"][@"more"];
 for (NSDictionary *dic1 in dic[@"result"][@"data"]) {
 
 ExpressionDetailModel *model = [[ExpressionDetailModel alloc]init];
 model.name = dic1[@"name"];
 model.image_url = dic1[@"image_url"];
 model.time_since1970 = [dic1[@"time_since1970"] longLongValue];
 model.image_id = [dic1[@"image_id"] longLongValue];
 model.expression_id = self.model.expression_id;
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
 -(void)insertCoreData:(ExpressionDetailModel*)model{
 
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
 */


/*
 //删除所有数据
 -(void)deleteData{
 
 AppDelegate *app = [[UIApplication sharedApplication]delegate];
 NSManagedObjectContext *context = [app managedObjectContext];
 NSEntityDescription *desc = [NSEntityDescription entityForName:@"ExpressionDetailEntity" inManagedObjectContext:context];
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
 #pragma mark - 刷新控件的代理方法
 #pragma mark 开始进入刷新状态
 - (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
 {
 ZFLog(@"----开始进入刷新状态");
 
 if ([refreshView isRefreshing]) {
 return;
 }
 // 添加数据
 if (refreshView == _header) {
 page = 0;
 
 [self getDataUrl:[NSString stringWithFormat:url_str,(long)page,self.model.expression_id]];
 }else
 {
 
 if ([moreStr isEqualToString:@"0"])
 {
 [self endRefresh];
 bottomLabel.hidden = NO;
 }else
 {
 
 page = page + 36;
 [self getDataUrl:[NSString stringWithFormat:url_str,(long)page,self.model.expression_id]];
 }
 }
 
 
 }
 
 #pragma mark 刷新完毕
 - (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
 {
 
 ExpressionDetailController *vc = self;
 
 
 if ([moreStr isEqualToString:@"0"]) {
 
 [vc performSelector:@selector(doneWithView) withObject:nil afterDelay:2.0];
 }
 
 ZFLog(@"----刷新完毕");
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
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
