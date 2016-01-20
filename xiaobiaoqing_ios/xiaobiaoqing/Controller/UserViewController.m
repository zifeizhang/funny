//
//  UserViewController.m
//  funnyji
//
//  Created by zhangzifei on 15/12/2.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITableView *userTableView;
    
    UIActionSheet *myActionSheet;
    
}

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.title = @"我的";
    [self initWithBackButton];
    
    userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    userTableView.dataSource = self;
    userTableView.delegate = self;
    [self.view addSubview:userTableView];
    [userTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    userTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *file = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"image.png"]];
    NSData *data = [NSData dataWithContentsOfFile:file];
    UIImage *iconImage = [UIImage imageWithData:data];
    
    
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo] || [ShareSDK hasAuthorized:SSDKPlatformTypeQQ] || [ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        userTableView.tableHeaderView = headerView;
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((headerView.frame.size.width-60)/2, 20, 60, 60)];
        iconImageView.layer.cornerRadius = 30;
        iconImageView.layer.masksToBounds = YES;
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"myhead"]];
        [headerView addSubview:iconImageView];
    }else{
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        userTableView.tableHeaderView = headerView;
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((headerView.frame.size.width-150)/2, 20, 150, 150)];
        iconImageView.layer.cornerRadius = 75;
        iconImageView.userInteractionEnabled = YES;
        iconImageView.tag = 30;
        iconImageView.layer.masksToBounds = YES;
        
        if (_icon == nil) {
            
            iconImageView.image = iconImage;
            
        }else{
        
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:_icon] placeholderImage:[UIImage imageNamed:@"myhead"]];
        }
        [headerView addSubview:iconImageView];
        
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadClick)];
        [iconImageView addGestureRecognizer:iconTap];
    }

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    
//    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    
//    // 检测网络连接的单例,网络变化时的回调方法
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"%d", status);
//    }];
}

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

-(void)uploadClick{

    myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
       
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
   
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *newImage = [self scaleImage:image toScale:0.3];
        NSData *data;
        if (UIImagePNGRepresentation(newImage) == nil)
        {
            data = UIImageJPEGRepresentation(newImage, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(newImage);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        NSString* filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //NSLog(@"filePath === %@",filePath);
        [self uploadImageWithImage:filePath];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showWithStatus:@"正在上传"];

        }];
        
        //类似微薄选择图后的效果
        UIImageView *smallimage = (UIImageView*)[self.view viewWithTag:30];
        smallimage.image = newImage;
    }
}
//图片上传
-(void)uploadImageWithImage:(NSString *)imagePath{

    NSString * str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info/update-phone";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"multipart/form-data"];  //multipart/form-data   text/html
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:str parameters:@{@"WebUser[uid]":_phoneNum} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        
        [formData appendPartWithFileData:data name:@"touxiang" fileName:imagePath mimeType:@"image/png" ];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"完成 %@", result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"错误 %@", error.localizedDescription);
    }];
    
}
//裁剪图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//
-(void)initWithBackButton{
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [btn setImage:[UIImage imageNamed:@"ico_back"]];
    [btn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btn;
}

-(void)backClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo] || [ShareSDK hasAuthorized:SSDKPlatformTypeQQ] || [ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"昵称：%@",[userInfo objectForKey:@"nickname"]];
        }else{
        
            cell.textLabel.text = [NSString stringWithFormat:@"退出登录"];
            cell.textLabel.textColor = [UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
    }else{
    
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"手机号码：%@",_phoneNum];
        }else{
        
            cell.textLabel.text = [NSString stringWithFormat:@"退出登录"];
            cell.textLabel.textColor = [UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [userTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
    
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        LoginViewController *vc = [[LoginViewController alloc]init];
        
        if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo] || [ShareSDK hasAuthorized:SSDKPlatformTypeQQ] || [ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
            
            if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo]) {
                
                [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                
                [userInfo setObject:@"" forKey:@"token"];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([ShareSDK hasAuthorized:SSDKPlatformTypeQQ]){
                
                [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                
                [userInfo setObject:@"" forKey:@"token"];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                
                [userInfo setObject:@"" forKey:@"token"];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            
            
            [userInfo setObject:@"0" forKey:@"isLogin"];
            [userInfo setObject:@"" forKey:@"iconP"];
            [userInfo setObject:@"" forKey:@"phoneNum"];
            [userInfo setObject:@"" forKey:@"token"];
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

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
