//
//  ImageViewController.m
//  funnyji
//
//  Created by zhangzifei on 16/1/9.
//  Copyright © 2016年 com.gohoc. All rights reserved.
//

#import "ImageViewController.h"
#import "AppDelegate.h"
#import "PictureCollectEntity.h"
@interface ImageViewController ()


//分享加载视图属性
@property(nonatomic,strong)UIView *panelView;
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",_model.d_gif_image_url]]placeholderImage:[UIImage imageNamed:@"hourglass"]];
    [self.view addSubview:imageView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    UIButton *shareBtn = [[UIButton alloc]init];
    shareBtn.frame = CGRectMake((self.view.frame.size.width-170)/2, imageView.frame.origin.y+250, 60, 40);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn setImage:[UIImage imageNamed:@"ico_share"] forState:UIControlStateNormal];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.view addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *collectBtn = [[UIButton alloc]init];
    collectBtn.frame = CGRectMake(shareBtn.frame.origin.x+shareBtn.frame.size.width+50, imageView.frame.origin.y+250, 60, 40);
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [collectBtn setImage:[UIImage imageNamed:@"ico_love"] forState:UIControlStateNormal];
    collectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.view addSubview:collectBtn];
    [collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)collectBtnClick{

    if (![self dataFetchRequestDetail2:_model]) {
        [self downloadImagemodel:_model];
        [self insertCoreData2:_model];
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
        [info setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    }
    
    if ([context save:&error]) {
        return YES;
    }else{
        
        return NO;
    }
}

-(void)shareBtnClick{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",_model.d_gif_image_url]];
    [self showShareActionSheet:self.view url:url model:_model];
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
//插入数据库
-(void)insertCoreData2:(PictureModel*)model{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"PictureCollectEntity" inManagedObjectContext:context];
    [entity setValue:[NSNumber numberWithLongLong:model.d_gif_image_id] forKey:@"d_gif_image_id"];
    [entity setValue:[NSNumber numberWithLongLong:model.time_since1970] forKey:@"time_since1970"];
    [entity setValue:model.name forKey:@"name"];
    [entity setValue:model.d_gif_image_url forKey:@"d_gif_image_url"];
    
    NSError *error;
    if (![context save:&error]) {
        ZFLog(@"不能保存:%@",[error localizedDescription]);
    }
    
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



-(void)backClick{

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
