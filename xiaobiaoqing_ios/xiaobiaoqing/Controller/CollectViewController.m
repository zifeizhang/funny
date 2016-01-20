//
//  CollectViewController.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/20.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "CollectViewController.h"
#import "ExpressionDetailModel.h"
#import "JokeModel.h"
#import "AppDelegate.h"
#import "ExpressionCollectEntity.h"
#import "jokeCollectCell.h"
#import "JokeCollectEntity.h"
#import "NSString+SelfSize.h"
#import "PictureCollectEntity.h"
#import "PictureModel.h"

#import "PictureCell.h"
#import "PackageViewController.h"

#define kMainWidth  ([UIScreen mainScreen].bounds.size.width - 30)/3
#define kMainwidth  ([UIScreen mainScreen].bounds.size.width - 40)/4

#define kMainHeight  [UIScreen mainScreen].bounds.size.height
#define bannerW  [UIScreen mainScreen].bounds.size.width
#define bannerH  [UIScreen mainScreen].bounds.size.height
#import "GDTMobBannerView.h"
@interface CollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,jokeCollectCellDelegate,GDTMobBannerViewDelegate>
{
    
    NSInteger row1;
    NSInteger row2;
    NSInteger row3;
    UILabel *labelTips;
    UIImageView *noImageView;
    
    GDTMobBannerView *_bannerView;
    
}
@property(nonatomic,strong)UISegmentedControl *segmentCtl;

//
@property(nonatomic,strong)NSMutableArray *dataArrayA;
@property(nonatomic,strong)NSMutableArray *dataArrayB;
@property(nonatomic,strong)NSMutableArray *dataArrayC;

@property(nonatomic,strong)UICollectionView *userCollectionView;

@property(nonatomic,strong)UITableView *userTableView;

@property(nonatomic,strong)PackageViewController *PackageVC;
//分享加载视图属性
@property(nonatomic,strong)UIView *panelView;
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;

@end

@implementation CollectViewController

-(id)init{
    
    if (self = [super init]) {
        
        _PackageVC = [[PackageViewController alloc]init];
        _dataArrayA = [NSMutableArray array];
        _dataArrayB = [NSMutableArray array];
        _dataArrayC = [NSMutableArray array];
        
        /*
         * 创建Banner广告View
         * "appkey" 指在 http://e.qq.com/dev/ 能看到的app唯一字符串
         * "placementId" 指在 http://e.qq.com/dev/ 生成的数字串，广告位id
         *
         * banner条的宽度开发者可以进行手动设置，用以满足开发场景需求或是适配最新版本的iphone，最佳显示效果为320
         * banner条的高度广点通侧强烈建议开发者采用推荐的高度50，否则显示效果会有影响
         */
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, kMainHeight-163,
                                                                         bannerW,
                                                                         bannerH)
                                                       appkey:@"1104962231"
                                                  placementId:@"1000404727559159"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = nil;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = [NSArray arrayWithObjects:@"表情图",@"动态图",@"段子",@"表情包",nil];
    _segmentCtl = [[UISegmentedControl alloc]initWithItems:array];
    _segmentCtl.frame = CGRectMake(0, 0, self.view.frame.size.width-60, 44);
    _segmentCtl.tintColor = [UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1];
    _segmentCtl.backgroundColor = [UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1];
    _segmentCtl.selectedSegmentIndex = 0;
    _segmentCtl.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1]);
    NSDictionary *selectedtextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [_segmentCtl setTitleTextAttributes:selectedtextAttributes forState:UIControlStateSelected];
    NSDictionary *unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:83/255.0 green:110/255.0 blue:0/255.0 alpha:1]};
    [_segmentCtl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [_segmentCtl addTarget:self action:@selector(clickSegmentBtn:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar addSubview:_segmentCtl];
    
    
    
    //-------------------------------------
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.userCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) collectionViewLayout:layout];
    self.userCollectionView.delegate = self;
    self.userCollectionView.dataSource = self;
    [self.view addSubview:self.userCollectionView];
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"PictureCell" bundle:nil] forCellWithReuseIdentifier:@"PictureCell"];
    self.userCollectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.userCollectionView.alwaysBounceVertical = YES;
    self.userCollectionView.showsVerticalScrollIndicator = NO;
    
    //-----------------------------------------
    
    self.userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    self.userTableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.userTableView.dataSource = self;
    self.userTableView.delegate = self;
    self.userTableView.hidden = YES;
    self.userTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.userTableView];
    [self.userTableView registerNib:[UINib nibWithNibName:@"jokeCollectCell" bundle:nil] forCellReuseIdentifier:@"jokeCollectCell"];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    footerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.userTableView.tableFooterView = footerView;

    
    //没有收藏时提示
    [self isCollectTips];
    
    //查询表情图片
    [self dataFetchRequest1];
    
    [self.userCollectionView reloadData];
    //初始化刷新（刷新数据库）
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(refreshButn)];
    [rightBtn setImage:[UIImage imageNamed:@"ico_repeat"]];
    [rightBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //添加手势
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.userCollectionView addGestureRecognizer:longPressGr];
    
    UILongPressGestureRecognizer *longPressGr1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo1:)];
    longPressGr1.minimumPressDuration = 1.0;
    [self.userTableView addGestureRecognizer:longPressGr1];
    
    //初始化分享View
    [self initWithShareSDKView];
    
    //初始化广告
    _bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    [self.view addSubview:_bannerView]; //添加到当前的view中
    [_bannerView loadAdAndShow]; //加载广告并展示
    
}

-(void)isCollectTips{

    noImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-115)/2, 60, 115, 115)];
    noImageView.image = [UIImage imageNamed:@"no.jpg"];
    noImageView.hidden = YES;
    [self.view bringSubviewToFront:noImageView];
    [self.view addSubview:noImageView];
    
    labelTips = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 260)/2, 205, 260, 80)];
    labelTips.text = @"        你当前还没有收藏哦 >_<        小f已经为你准备了千万个Funny集        现在就去挑选图片和段子吧 *_* ";
    labelTips.numberOfLines = 0;
    labelTips.font = [UIFont systemFontOfSize:17];
    labelTips.hidden = YES;
    labelTips.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [self.view bringSubviewToFront:labelTips];
    [self.view addSubview:labelTips];
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
    
    if (_segmentCtl.selectedSegmentIndex == 0) {
        if (_dataArrayA.count > 0) {
            [_dataArrayA removeAllObjects];
        }
        [self dataFetchRequest1];
        [self.userCollectionView reloadData];
        
    }else if (_segmentCtl.selectedSegmentIndex == 1){
        
        if (_dataArrayB.count > 0) {
            [_dataArrayB removeAllObjects];
        }
        [self dataFetchRequest2];
        [self.userCollectionView reloadData];
        
    }else if (_segmentCtl.selectedSegmentIndex == 3){
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil userInfo:nil];
        
    }else{
        
        if (_dataArrayC.count > 0) {
            
            [_dataArrayC removeAllObjects];
        }
        [self dataFetchRequest3];
        [self.userTableView reloadData];
    }
    
}
-(void)longPressToDo:(UILongPressGestureRecognizer*)gesture{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
            CGPoint point = [gesture locationInView:self.userCollectionView];
            NSIndexPath * indexPath = [self.userCollectionView indexPathForItemAtPoint:point];
            if(indexPath == nil) return ;
            //add your code here
        
        if (_segmentCtl.selectedSegmentIndex == 0) {
            
            UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"删除" message:@"确定要删除这张图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            row1 = indexPath.item;
            [alertView1 show];
            
        }else{
        
            UIAlertView *alertView2 = [[UIAlertView alloc]initWithTitle:@"删除" message:@"确定要删除这张图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            row2 = indexPath.item;
            [alertView2 show];
            
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (_segmentCtl.selectedSegmentIndex == 0) {
        
        if (buttonIndex == 0) {
            
        }else{
        
            ExpressionDetailModel *model = _dataArrayA[row1];
            [self deleteFetchRequestDetail1:model];
            
            if (_dataArrayA.count > 0) {
                [_dataArrayA removeAllObjects];
            }
            [self dataFetchRequest1];
            [self.userCollectionView reloadData];
        }
        
    }else if (_segmentCtl.selectedSegmentIndex == 1){
    
        if (buttonIndex == 0) {
            
        }else{
            
            PictureModel *model = _dataArrayB[row2];
            [self deleteFetchRequestDetail2:model];
            if (_dataArrayB.count > 0) {
                [_dataArrayB removeAllObjects];
            }
            [self dataFetchRequest2];
            [self.userCollectionView reloadData];
        }
        
    }else{
    
        if (buttonIndex == 0) {
            
        }else{
            
            JokeModel *model = _dataArrayC[row3];
            [self deleteFetchRequestDetail3:model];
            if (_dataArrayC.count > 0) {
                
                [_dataArrayC removeAllObjects];
            }
            [self dataFetchRequest3];
            [self.userTableView reloadData];
        }
    }
}

-(void)longPressToDo1:(UILongPressGestureRecognizer*)gesture{

    if(gesture.state == UIGestureRecognizerStateBegan){
    
        CGPoint point = [gesture locationInView:self.userTableView];
        NSIndexPath * indexPath = [self.userTableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        //add your code here
        
        UIAlertView *alertView3 = [[UIAlertView alloc]initWithTitle:@"删除" message:@"确定要删除这个段子吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        row3 = indexPath.row;
        [alertView3 show];
    }
    
}
-(void)clickSegmentBtn:(UISegmentedControl*)segmentBtn{
    
    if (segmentBtn.selectedSegmentIndex == 0) {

        self.userTableView.hidden = YES;
        [_PackageVC.view removeFromSuperview];
        if (_dataArrayA.count > 0) {
            [_dataArrayA removeAllObjects];
        }
        [self dataFetchRequest1];
        [self.userCollectionView reloadData];
        
    }else if (segmentBtn.selectedSegmentIndex == 1){

        self.userTableView.hidden = YES;
        [_PackageVC.view removeFromSuperview];
        if (_dataArrayB.count > 0) {
            [_dataArrayB removeAllObjects];
        }
        
        [self dataFetchRequest2];
        [self.userCollectionView reloadData];
        
    }else if (segmentBtn.selectedSegmentIndex == 2){
        
        [_PackageVC.view removeFromSuperview];
        self.userTableView.hidden = NO;
        if (_dataArrayC.count > 0) {
            [_dataArrayC removeAllObjects];
        }
        [self dataFetchRequest3];
        [self.userTableView reloadData];
        
    }else{
    
        _PackageVC.view.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
        [self addChildViewController:_PackageVC];
        [self.view addSubview:_PackageVC.view];
    }
    
}

#pragma mark - 表情图片
//查询所有数据
-(void)dataFetchRequest1{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"ExpressionCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    for (ExpressionCollectEntity *info in fetchObjects) {
        
        ExpressionDetailModel *model = [[ExpressionDetailModel alloc]init];
        model.image_id = [[info valueForKey:@"image_id"] longLongValue];
        model.name = [info valueForKey:@"name"];
        model.image_url = [info valueForKey:@"image_url"];
        model.time_since1970 = [[info valueForKey:@"time_since1970"] longLongValue];
        [_dataArrayA addObject:model];
    }
    [self.userCollectionView reloadData];
    
    if (_dataArrayA.count <= 0) {
        labelTips.hidden = NO;
        noImageView.hidden = NO;
    }else{
    
        labelTips.hidden = YES;
        noImageView.hidden = YES;
    }
}
//条件删除一条数据
-(void)deleteFetchRequestDetail1:(ExpressionDetailModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"ExpressionCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(image_id = %@)",[NSNumber numberWithLongLong:model.image_id]];
    NSError *error;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in datas) {
        
        [context deleteObject:obj];
    }
    if ([context save:&error]) {
        NSLog(@"删除成功");
    }
}
#if 0
//删除所有数据
-(void)deleteData{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"ExpressionCollectEntity" inManagedObjectContext:context];
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
#endif

#pragma mark - 动态图片
//查询所有数据
-(void)dataFetchRequest2{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"PictureCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    for (PictureCollectEntity *info in fetchObjects) {
        
        PictureModel *model = [[PictureModel alloc]init];
        model.d_gif_image_id = [[info valueForKey:@"d_gif_image_id"] longLongValue];
        model.name = [info valueForKey:@"name"];
        model.d_gif_image_url = [info valueForKey:@"d_gif_image_url"];
        model.first_icon_url = [info valueForKey:@"first_icon_url"];
        model.time_since1970 = [[info valueForKey:@"time_since1970"] longLongValue];
        [_dataArrayB addObject:model];
    }
    [self.userCollectionView reloadData];
    
    if (_dataArrayB.count <= 0) {
        labelTips.hidden = NO;
        noImageView.hidden = NO;
    }else{
    
        labelTips.hidden = YES;
        noImageView.hidden = YES;
    }
}
//条件删除一条数据
-(void)deleteFetchRequestDetail2:(PictureModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"PictureCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    request.predicate = [NSPredicate predicateWithFormat:@"(d_gif_image_id = %@)",[NSNumber numberWithLongLong:model.d_gif_image_id]];
    NSError *error;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in datas) {
        
        [context deleteObject:obj];
    }
    
    if ([context save:&error]) {
        NSLog(@"删除成功");
    }
    [self.userCollectionView reloadData];
}
#pragma mark - 段子

//查询所有数据
-(void)dataFetchRequest3{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"JokeCollectEntity" inManagedObjectContext:context];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    for (JokeCollectEntity *info in fetchObjects) {
        
        JokeModel *model = [[JokeModel alloc]init];
        model.joke_id = [[info valueForKey:@"joke_id"] longLongValue];
        model.joke_content = [info valueForKey:@"joke_content"];
        model.time_since1970 = [[info valueForKey:@"time_since1970"] longLongValue];
        [_dataArrayC addObject:model];
    }
    [self.userTableView reloadData];
    if (_dataArrayC.count <= 0) {
        labelTips.hidden = NO;
        noImageView.hidden = NO;
    }else{
        labelTips.hidden = YES;
        noImageView.hidden = YES;
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
    [self.userTableView reloadData];
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_segmentCtl.selectedSegmentIndex == 0) {
        return _dataArrayA.count;
    }else
    {
        return _dataArrayB.count;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    
    if (_segmentCtl.selectedSegmentIndex == 0) {

        ExpressionDetailModel *model = _dataArrayA[indexPath.item];
        [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.image_url]]placeholderImage:[UIImage imageNamed:@"hourglass"]];
        
    }else{
    
        PictureModel *model = _dataArrayB[indexPath.item];
        [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.d_gif_image_url]]placeholderImage:[UIImage imageNamed:@"hourglass"]];
        
    }

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_segmentCtl.selectedSegmentIndex == 0) {
        return CGSizeMake(kMainwidth, kMainwidth);
    }else{
    
        return CGSizeMake(kMainWidth, kMainWidth);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (_segmentCtl.selectedSegmentIndex == 0) {
        
        ExpressionDetailModel *model = _dataArrayA[indexPath.item];
        UICollectionViewCell *cell = [self.userCollectionView cellForItemAtIndexPath:indexPath];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.image_url]];
        [self showShareActionSheet:cell url:url model:model];

    }else{
        
        PictureModel *model = _dataArrayB[indexPath.item];
        UICollectionViewCell *cell = [self.userCollectionView cellForItemAtIndexPath:indexPath];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.d_gif_image_url]];
        [self showShareActionSheet1:cell url:url model:model];
    }
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArrayC.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    jokeCollectCell *cell = [self.userTableView dequeueReusableCellWithIdentifier:@"jokeCollectCell"];
    JokeModel *model = _dataArrayC[indexPath.section];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",model.joke_content];
    
    cell.delegate = self;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JokeModel *model = _dataArrayC[indexPath.section];
    
    CGSize size = [model.joke_content getSizeFromSelfWithWidth:_userTableView.frame.size.width - 40 andFont:16];
    
    return size.height + 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    self.userTableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.userTableView deselectRowAtIndexPath:indexPath animated:YES];
    jokeCollectCell *cell = [self.userTableView cellForRowAtIndexPath:indexPath];
    JokeModel *model = _dataArrayC[indexPath.section];
    [self showShareActionSheet:cell text:model.joke_content];
    
}
#pragma mark - jokeCollectCellDelegate

-(void)cancelCollectBtn:(jokeCollectCell *)cell{

    NSIndexPath *path = [self.userTableView indexPathForCell:cell];
    
    JokeModel *model = _dataArrayC[path.section];
    [self deleteFetchRequestDetail3:model];
    if (_dataArrayC.count > 0) {
        
        [_dataArrayC removeAllObjects];
    }
    [self dataFetchRequest3];
    [self.userTableView reloadData];
}
-(void)shareCollectBtn:(jokeCollectCell *)cell{

    NSIndexPath *path = [self.userTableView indexPathForCell:cell];
    JokeModel *model = _dataArrayC[path.section];
    [self showShareActionSheet:cell text:model.joke_content];

}

//显示分享菜单
- (void)showShareActionSheet1:(UIView *)view url:(NSURL*)url model:(PictureModel*)model
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.gif",model.d_gif_image_id]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSArray* imageArray = @[[UIImage imageWithData:data]];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:nil
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupWeChatParamsByText:@"asdf"
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
    
    [shareParams SSDKSetupQQParamsByText:nil
                                   title:nil
                                     url:nil
                              thumbImage:nil
                                   image:url
                                    type:SSDKContentTypeImage
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"shareSdk"
                                               title:@""
                                               image:filePath
                                                 url:url
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeImage];
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

//显示分享菜单
- (void)showShareActionSheet:(UIView *)view url:(NSURL*)url model:(ExpressionDetailModel*)model
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",model.image_id]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil) {
        return;
    }
    NSArray* imageArray = @[[UIImage imageWithData:data]];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:nil
                                      title:@"来自Funny集"
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupWeChatParamsByText:@"asdf"
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
    
    [shareParams SSDKSetupQQParamsByText:nil
                                   title:@"来自Funny集"
                                     url:nil
                              thumbImage:nil
                                   image:url
                                    type:SSDKContentTypeImage
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"f"
                                               title:@"来自Funny集"
                                               image:[NSData dataWithContentsOfFile:filePath]
                                                 url:url
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeImage];
    
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
                                      title:@"分享标题"
                                       type:SSDKContentTypeText];
    [shareParams SSDKSetupCopyParamsByText:str
                                    images:nil
                                       url:nil
                                      type:SSDKContentTypeText];
    
    
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
                                                                     items:nil
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

#pragma mark - GDTMobBannerViewDelegate
// 请求广告条数据成功后调用
- (void)bannerViewDidReceived{

//    ZFLog(@"Received---------请求广告条数据成功--------");
}
// 请求广告条数据失败后调用
- (void)bannerViewFailToReceived:(NSError*)errCode{

    [_bannerView loadAdAndShow];
//    ZFLog(@"FailToReceived-------请求广告条数据失败---------------");
}
// 全屏广告弹出时调用
- (void)bannerViewDidPresentScreen{

    ZFLog(@"PresentScreen----------------");
}
// 全屏广告关闭时调用
- (void)bannerViewDidDismissScreen{

    ZFLog(@"DismissScreen-----------------");
}
// 应用进入后台时调用
- (void)bannerViewWillLeaveApplication{

    ZFLog(@"WillLeaveApplication-----应用进入后台时调用-----------");
}
// 广告条曝光回调
- (void)bannerViewWillExposure{

//    ZFLog(@"Exposure---------------------");
}
// 广告条点击回调
- (void)bannerViewClicked{

    ZFLog(@"Clicked---------------");
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshInterface" object:nil];
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
