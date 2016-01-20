//
//  RegistViewController.m
//  funnyji
//
//  Created by zhangzifei on 15/12/3.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "RegistViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#define TIMEOVERSECONDS 120.0
#define image_url @"http://xiaobiaoqing.gohoc.com/index.php?r=yan-zheng/get-img"

@interface RegistViewController ()<UITextFieldDelegate>{

    NSTimer *timer;
    UIButton *testBtn;
    int seconds;
    NSString *yanZhengMa;
    NSString *yanZhengImage;
    
    NSDate *passTime;
    UIImageView *yZ_imageView;
    
    BOOL isBack;
}

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    seconds = TIMEOVERSECONDS;
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self initWithBackButton];
    [self initWithTextField];
    
    [self getDataUrl:image_url];
    
    yZ_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    yZ_imageView.userInteractionEnabled = YES;
    yZ_imageView.image = [UIImage imageNamed:@"ico_repeat"];
    yZ_imageView.layer.cornerRadius = 5;
    yZ_imageView.layer.masksToBounds = YES;
    //[self.view addSubview:yZ_imageView];
    
    UITextField *imageField = [[UITextField alloc]initWithFrame:CGRectMake(20, 60, self.view.frame.size.width-40, 30)];
    
    imageField.borderStyle = UITextBorderStyleRoundedRect;
    imageField.placeholder = @"请输入图片验证码";
    imageField.autocorrectionType = UITextAutocorrectionTypeNo;
    imageField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    imageField.clearButtonMode = UITextFieldViewModeWhileEditing;
    imageField.delegate = self;
    imageField.tag = 54;
    imageField.backgroundColor = [UIColor whiteColor];
    imageField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:imageField];
    imageField.rightViewMode = UITextFieldViewModeAlways;
    imageField.rightView = yZ_imageView;
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)];
    [yZ_imageView addGestureRecognizer:imageTap];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
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

-(void)imageClick{

    [self getDataUrl:image_url];
}

-(void)getDataUrl:(NSString*)Url{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        
        NSLog(@"dic ==== %@",dic);
        
        yZ_imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"result"][@"data"][@"url"]]]];
        yanZhengImage = dic[@"result"][@"data"][@"code"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
        
    }];
    
}

-(void)initWithBackButton{
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [btn setImage:[UIImage imageNamed:@"ico_back"]];
    [btn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btn;
}
//初始化文本框
-(void)initWithTextField{

    NSArray *imageArr = [NSArray arrayWithObjects:@"regedit",@"",@"lock",@"lock", nil];
    NSArray *nameArr = [NSArray arrayWithObjects:@"请输入手机号码",@"请输入手机验证码",@"请输入密码",@"请再次输入密码", nil];
    for (int i = 0; i < imageArr.count; i++) {
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 60+(i*(30+10)), self.view.frame.size.width-40, 30)];
        
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = [nameArr objectAtIndex:i];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardType = UIKeyboardTypeDefault;
        
        if (i == 2 || i == 3) {
            textField.secureTextEntry = YES;
        }
        [self.view addSubview:textField];
        textField.tag = 50 + i;
        
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            UITextField *text = (UITextField*)[self.view viewWithTag:50];
            CGRect rectF = text.frame;
            rectF.origin.y = 20;
            text.frame = rectF;
        }
        
        if (i != 1) {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            UIImageView *headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imageArr objectAtIndex:i]]];
            headImage.frame = CGRectMake(6, 3, 24, 24);
            [backView addSubview:headImage];
            textField.leftView = backView;
            textField.leftViewMode = UITextFieldViewModeAlways;
        }
        if (i == 1) {
            UIView *backView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, 100, 30)];
            testBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
            testBtn.frame = CGRectMake(0, 0, 100, 30);
            [testBtn.layer setCornerRadius:5];
            testBtn.layer.masksToBounds = YES;
            [testBtn setTitle:@"验证码" forState:UIControlStateNormal];
            [testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [testBtn setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
            [testBtn addTarget:self action:@selector(testBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:testBtn];
            [textField setRightView:backView];
            textField.rightViewMode = UITextFieldViewModeAlways;
        }
    }
    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 230, (self.view.frame.size.width-40), 30)];
    [registBtn.layer setCornerRadius:5];
    registBtn.tag = 6;
    registBtn.enabled = NO;
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [registBtn setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
    [registBtn addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-120)/2, 275, 120, 30)];
    label.text = @"第三方账号注册";
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 290, (self.view.frame.size.width-40-120)/2, 1)];
    line1.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.view addSubview:line1];
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(20+(self.view.frame.size.width-40-120)/2+120, 290, (self.view.frame.size.width-40-120)/2, 1)];
    line2.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.view addSubview:line2];
    
    NSArray *logoArr = [NSArray arrayWithObjects:@"ico_weixin",@"ico_qq",@"ico_sina", nil];
    for (int i = 0; i < logoArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+i*((self.view.frame.size.width-80)/3 + 20), 300, (self.view.frame.size.width-80)/3, (self.view.frame.size.width-80)/3);
        [btn setImage:[UIImage imageNamed:[logoArr objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

-(void)testBtnClick:(UIButton *)btn{

    
    UITextField *textField0 = (UITextField*)[self.view viewWithTag:50];
    UITextField *textField1 = (UITextField*)[self.view viewWithTag:54];
    
    if (textField0.text.length == 0) {
        return;
    }
    
    
    if (![yanZhengImage isEqualToString:[textField1.text uppercaseString]]) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"验证码输入错误，请重新输入"];
        [self getDataUrl:image_url];
        return;
    }
    
    passTime = [NSDate date];
    //NSLog(@"now === %@",passTime);
    
    
    if (!timer) {
//        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOver) userInfo:nil repeats:YES];
//        testBtn.userInteractionEnabled = NO;
        
        
        NSDictionary *dic = @{@"yanZhengMa":textField0.text};
        
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        NSString *str = [NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/index.php?r=set-info/get-code&phone=%@",textField0.text];
        [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功");
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
            
            int code = [dic[@"c"] intValue];
            if (code == 0) {
                NSLog(@"code === %@",dic[@"code"]);
                yanZhengMa = dic[@"code"];
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOver) userInfo:nil repeats:YES];
                testBtn.userInteractionEnabled = NO;

            }else{
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            }
            NSLog(@"dic === %@",dic);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败 == %@",error);
        }];
    }
    
}

-(void)timeOver{

    seconds --;
    if (seconds <= 0) {
        [timer invalidate];
        timer = nil;
        seconds = TIMEOVERSECONDS;
        testBtn.userInteractionEnabled = YES;
        [testBtn setTitle:@"验证码" forState:UIControlStateNormal];
        return;
    }
    
    [testBtn setTitle:[NSString stringWithFormat:@"%d s",seconds] forState:UIControlStateNormal];
    
}
-(void)btnAction:(UIButton*)btn{

    if (btn.tag == 100) {
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess)
            {
                
//                NSLog(@"uid=%@",user.uid);
//                NSLog(@"%@",user.credential);
//                NSLog(@"token=%@",user.credential.token);
//                NSLog(@"nickname=%@",user.nickname);
//                NSLog(@"icon=%@",user.icon);
                
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setObject:user.icon forKey:@"icon"];
                [userInfo setObject:user.nickname forKey:@"nickname"];
                
                NSDictionary *dic = @{@"platformType":@"weixin",@"nickname":user.nickname,@"uid":user.uid,@"icon":user.icon};
                
                AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
                
                manager.responseSerializer=[AFHTTPResponseSerializer serializer];
                
                NSString *str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info%2Fset-user";
                [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
                    if ([dic[@"error"] isEqualToString:@"0"]) {
                        [userInfo setObject:dic[@"result"][@"token"] forKey:@"token"];
                        UserViewController *userVC = [[UserViewController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:userVC animated:YES];
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:@"注册失败"];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"注册失败"];
                }];

            }
            
            else
            {
                NSLog(@"%@",error);
            }
            
        }];
        
    }
    if (btn.tag == 101) {
        
        //例如QQ的登录
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 
//                 NSLog(@"uid=%@",user.uid);
//                 NSLog(@"%@",user.credential);
//                 NSLog(@"token=%@",user.credential.token);
//                 NSLog(@"nickname=%@",user.nickname);
//                 NSLog(@"icon=%@",user.icon);
                 
                 NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                 [userInfo setObject:user.icon forKey:@"icon"];
                 [userInfo setObject:user.nickname forKey:@"nickname"];
                 
                 NSDictionary *dic = @{@"platformType":@"qq",@"nickname":user.nickname,@"uid":user.uid,@"icon":user.icon};
                 
                 AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
                 
                 manager.responseSerializer=[AFHTTPResponseSerializer serializer];
                 NSString *str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info%2Fset-user";
                 [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
                     if ([dic[@"error"] isEqualToString:@"0"]) {
                         [userInfo setObject:dic[@"result"][@"token"] forKey:@"token"];
                         UserViewController *userVC = [[UserViewController alloc]init];
                         self.hidesBottomBarWhenPushed = YES;
                         [self.navigationController pushViewController:userVC animated:YES];
                     }else{
                         
                         [SVProgressHUD showErrorWithStatus:@"注册失败"];
                     }
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [SVProgressHUD showErrorWithStatus:@"注册失败"];
                 }];

             }
             else
             {
                 NSLog(@"%@",error);
             }
         }];
    }
    if (btn.tag == 102) {
        
        [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess)
            {
                
//                NSLog(@"uid=%@",user.uid);
//                NSLog(@"%@",user.credential);
//                NSLog(@"token=%@",user.credential.token);
//                NSLog(@"nickname=%@",user.nickname);
//                NSLog(@"icon=%@",user.icon);
                
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setObject:user.icon forKey:@"icon"];
                [userInfo setObject:user.nickname forKey:@"nickname"];
                
                NSDictionary *dic = @{@"platformType":@"xinlang",@"nickname":user.nickname,@"uid":user.uid,@"icon":user.icon};
                
                AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
                
                manager.responseSerializer=[AFHTTPResponseSerializer serializer];
                NSString *str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info%2Fset-user";
                [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
                    
                    if ([dic[@"error"] isEqualToString:@"0"]) {
                        [userInfo setObject:dic[@"result"][@"token"] forKey:@"token"];
                        UserViewController *userVC = [[UserViewController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:userVC animated:YES];
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:@"注册失败"];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"注册失败"];
                }];
                
            }
            
            else
            {
                NSLog(@"%@",error);
            }
            
        }];
        
    }

}
-(void)registClick:(UIButton*)btn{

    UITextField *textField0 = (UITextField*)[self.view viewWithTag:50];
    UITextField *textField1 = (UITextField*)[self.view viewWithTag:51];
    UITextField *textField2 = (UITextField*)[self.view viewWithTag:52];
    UITextField *textField3 = (UITextField*)[self.view viewWithTag:53];
    
    NSDate *currentTime = [NSDate date];
    //NSLog(@"over === %@",currentTime);
    NSTimeInterval time = [currentTime timeIntervalSinceDate:passTime];
    //NSLog(@"time ====== %f",time);
    
    if (time > TIMEOVERSECONDS) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"你输入的验证码已过期，请重新获取输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }else{
    
        if (![[textField1.text lowercaseString] isEqualToString:yanZhengMa]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"你输入的验证码不正确，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        
    }
    
    if (![self isMobileNumber:textField0.text] || textField2.text.length < 6 || textField3.text.length < 6) {
        return;
    }
    
    if (![textField2.text isEqualToString:textField3.text]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码输入不一致，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }else{
    
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"正在注册"];
        NSDictionary *dic = @{@"uid":textField0.text,@"password":textField2.text,@"platformType":@"phone"};
        
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        NSString *str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info%2Fset-phone";
        
        [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
            NSLog(@"dic === %@",dic);
            if ([dic[@"error"] isEqualToString:@"0"]) {
                
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [self performSelector:@selector(loginView) withObject:self afterDelay:1];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
        }];
    }
}
-(void)loginView{

    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//当textField编辑结束时调用的方法
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    UITextField *textField0 = (UITextField*)[self.view viewWithTag:50];
    UITextField *textField1 = (UITextField*)[self.view viewWithTag:51];
    UITextField *textField2 = (UITextField*)[self.view viewWithTag:52];
    UITextField *textField3 = (UITextField*)[self.view viewWithTag:53];
    
    if (textField.tag == 50) {
        
        if (![self isMobileNumber:textField.text] && !isBack) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"你输入的手机号码格式不对，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }else{
    
        if (textField.tag == 52) {
            if (textField2.text.length < 6 && !isBack) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码不能少于6位，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alertView show];
                return;
            }

        }else{
        
            if (textField.tag == 53)
            {
                if (textField3.text.length < 6 && !isBack) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码不能少于6位，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    
                    [alertView show];
                    return;
                }
                
                if (![textField2.text isEqualToString:textField3.text] && !isBack)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码输入不一致，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }else
                {
                    if (textField0.text.length != 0 && textField1.text.length != 0 && textField2.text.length != 0 && textField3.text.length != 0)
                    {
                        UIButton *btn = (UIButton*)[self.view viewWithTag:6];
                        btn.enabled = YES;
                        [btn setBackgroundColor:[UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1]];
                    }
                    
                }
            }

        }
        
    }
    
}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//当开始点击textField会调用的方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    UIButton *btn = (UIButton*)[self.view viewWithTag:6];
    btn.enabled = NO;
    [btn setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
    
    if (textField.tag == 53) {
        
        CGRect rectf = self.view.frame;
        rectf.origin.y = 34;
        self.view.frame = rectf;
    }else{
    
        CGRect rectf = self.view.frame;
        rectf.origin.y = 64;
        self.view.frame = rectf;
    }
    
}
-(void)backClick{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
//    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    [firstResponder resignFirstResponder];
    
    for (int i = 0; i < 4;i++) {
        UITextField *firstResponder = (UITextField*)[self.view viewWithTag:50+i];
        [firstResponder resignFirstResponder];
        if (i == 3) {
            CGRect rectf = self.view.frame;
            rectf.origin.y = 64;
            self.view.frame = rectf;
        }
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (textField.tag == 53) {
        
        CGRect rectf = self.view.frame;
        rectf.origin.y = 64;
        self.view.frame = rectf;
    }
    
    return YES;
    
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
