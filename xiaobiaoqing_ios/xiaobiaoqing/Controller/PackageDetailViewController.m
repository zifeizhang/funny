//
//  PackageDetailViewController.m
//  funnyji
//
//  Created by zhangzifei on 16/1/19.
//  Copyright © 2016年 com.gohoc. All rights reserved.
//

#import "PackageDetailViewController.h"
#import "AppDelegate.h"
#import "ExpressionDetailEntity.h"
#import "ExpressionDetailModel.h"
#import "PackageImageCell.h"
#define kMainWidth  ([UIScreen mainScreen].bounds.size.width - 40)/4
@interface PackageDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UICollectionView *userCollectionView;
//分享加载视图属性
@property(nonatomic,strong)UIView *panelView;
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;
@end

@implementation PackageDetailViewController

-(id)init{
    
    if (self = [super init]) {
        
        _dataArr = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.title = _model.name;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [backButton setImage:[UIImage imageNamed:@"ico_back"]];
    [backButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.userCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)collectionViewLayout:layout];
    self.userCollectionView.delegate = self;
    self.userCollectionView.dataSource = self;
    [self.view addSubview:self.userCollectionView];
    self.userCollectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.userCollectionView.alwaysBounceVertical = YES;
    self.userCollectionView.showsVerticalScrollIndicator = NO;
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"PackageImageCell" bundle:nil] forCellWithReuseIdentifier:@"PackageImageCell"];
    
    //初始化分享View
    [self initWithShareSDKView];
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

-(void)backClick{

    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{

    [_dataArr removeAllObjects];
    [self dataFetchRequest];
}
/**
 *  查询所有数据
 */
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
#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ExpressionDetailModel *model = _dataArr[indexPath.row];

    PackageImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PackageImageCell" forIndexPath:indexPath];
    
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpressionDetailModel *model = _dataArr[indexPath.row];
    
    UICollectionViewCell *cell = [self.userCollectionView cellForItemAtIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.image_url]];
    
    [self showShareActionSheet:cell model:model url:(NSURL*)url];
    
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
