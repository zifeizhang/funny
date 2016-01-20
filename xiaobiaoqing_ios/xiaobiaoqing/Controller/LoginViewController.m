//
//  LoginViewController.m
//  funnyji
//
//  Created by zhangzifei on 15/12/3.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "LoginViewController.h"
#import "UserViewController.h"
#import "RegistViewController.h"
#import "PasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{


    BOOL isBack;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self initWithBackButton];
    [self initWithTextField];
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
-(void)initWithBackButton{
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [btn setImage:[UIImage imageNamed:@"ico_back"]];
    [btn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btn;
}

-(void)backClick{
    
    isBack = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//初始化文本框
-(void)initWithTextField{
    
    NSArray *imageArr = [NSArray arrayWithObjects:@"regedit",@"lock", nil];
    NSArray *nameArr = [NSArray arrayWithObjects:@"请输入手机号码",@"请输入密码", nil];
    for (int i = 0; i < imageArr.count; i++) {
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 40+(i*(30+30)), (self.view.frame.size.width-40), 30)];
        
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = [nameArr objectAtIndex:i];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardType = UIKeyboardTypeDefault;
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        if (i == 1) {
            textField.secureTextEntry = YES;
        }
        [self.view addSubview:textField];
        textField.tag = 50 + i;
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImageView *headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imageArr objectAtIndex:i]]];
        headImage.frame = CGRectMake(6, 3, 24, 24);
        [backView addSubview:headImage];
        textField.leftView = backView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 160, (self.view.frame.size.width-40), 30)];
    [loginBtn.layer setCornerRadius:5];
    loginBtn.tag = 6;
    loginBtn.enabled = NO;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [loginBtn setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
//    UIButton *autoLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(40+(self.view.frame.size.width-80)/3, 200, (self.view.frame.size.width-80)/3, 30)];
//    [autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
//    autoLoginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [autoLoginBtn setTitleColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1] forState:UIControlStateNormal];
//    [autoLoginBtn addTarget:self action:@selector(autoLoginClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:autoLoginBtn];
    
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, (self.view.frame.size.width-80)/3, 30)];
    [registerBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerBtn setTitleColor:[UIColor colorWithRed:242/255.0 green:150/255.0 blue:23/255.0 alpha:1] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];

    
    UIButton *forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(60+(self.view.frame.size.width-80)/3*2, 200, (self.view.frame.size.width-80)/3, 30)];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn setTitleColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-120)/2, 245, 120, 30)];
    label.text = @"第三方账号登录";
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 260, (self.view.frame.size.width-40-120)/2, 1)];
    line1.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.view addSubview:line1];
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(20+(self.view.frame.size.width-40-120)/2+120, 260, (self.view.frame.size.width-40-120)/2, 1)];
    line2.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.view addSubview:line2];
    
    NSArray *logoArr = [NSArray arrayWithObjects:@"ico_weixin",@"ico_qq",@"ico_sina", nil];
    for (int i = 0; i < logoArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+i*((self.view.frame.size.width-80)/3 + 20), 270, (self.view.frame.size.width-80)/3, (self.view.frame.size.width-80)/3);
        [btn setImage:[UIImage imageNamed:[logoArr objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}
-(void)btnAction:(UIButton*)btn{
    
    if (btn.tag == 100) {
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
                  conditional:nil
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess)
            {
                
                NSLog(@"uid=%@",user.uid);
                NSLog(@"%@",user.credential);
                NSLog(@"token=%@",user.credential.token);
                NSLog(@"nickname=%@",user.nickname);
                NSLog(@"icon=%@",user.icon);
                
                
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
                        
                        [SVProgressHUD showErrorWithStatus:@"登录失败"];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
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
                 
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
                 NSLog(@"icon=%@",user.icon);
                 
                 
                 NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                 [userInfo setObject:user.icon forKey:@"icon"];
                 [userInfo setObject:user.nickname forKey:@"nickname"];
                 
                 NSDictionary *dic = @{@"platformType":@"qq",@"nickname":user.nickname,@"uid":user.uid,@"icon":user.icon};
                 
                 AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
                 
                 manager.responseSerializer=[AFHTTPResponseSerializer serializer];
                 
                 NSString *str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info%2Fset-user";
                 [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
                     
                     NSLog(@"dic ==== %@",dic);
                     
                     if ([dic[@"error"] isEqualToString:@"0"]) {
                         [userInfo setObject:dic[@"result"][@"token"] forKey:@"token"];
                         UserViewController *userVC = [[UserViewController alloc]init];
                         self.hidesBottomBarWhenPushed = YES;
                         [self.navigationController pushViewController:userVC animated:YES];
                     }else{
                         [userInfo setObject:@"" forKey:@"token"];
                         [SVProgressHUD showErrorWithStatus:@"登录失败"];
                     }

                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [SVProgressHUD showErrorWithStatus:@"登录失败"];
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
                
                NSLog(@"uid=%@",user.uid);
                NSLog(@"%@",user.credential);
                NSLog(@"token=%@",user.credential.token);
                NSLog(@"nickname=%@",user.nickname);
                NSLog(@"icon=%@",user.icon);
                
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setObject:user.icon forKey:@"icon"];
                [userInfo setObject:user.nickname forKey:@"nickname"];
                
                NSDictionary *dic = @{@"platformType":@"xinlang",@"nickname":user.nickname,@"uid":user.uid,@"icon":user.icon};
                
                AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
                
                manager.responseSerializer=[AFHTTPResponseSerializer serializer];
                NSString *str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info%2Fset-user";
                [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"dic === %@",dic);
                    if ([dic[@"error"] isEqualToString:@"0"]) {
                        [userInfo setObject:dic[@"result"][@"token"] forKey:@"token"];
                        UserViewController *userVC = [[UserViewController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:userVC animated:YES];
                    }else{
                    
                        [SVProgressHUD showErrorWithStatus:@"登录失败"];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                }];
                
                //
            }
            
            else
            {
                NSLog(@"%@",error);
            }
            
        }];
        
    }
}

-(void)loginClick:(UIButton*)btn{
    
    UITextField *textField1 = (UITextField*)[self.view viewWithTag:50];
    UITextField *textField2 = (UITextField*)[self.view viewWithTag:51];
    
    if (textField1.text.length == 0 || textField2.text.length == 0) {
        
        if (textField1.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入手机号码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        if (textField2.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }else{
        
        if (textField1.text.length == 0 || textField2.text.length == 0){
        
            return;
        }
        
        if (![self isMobileNumber:textField1.text]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"你输入的手机号码格式不对，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
        if (textField2.text.length < 6) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码不能少于6位，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"正在登录"];
        NSDictionary *dic = @{@"phone":textField1.text,@"password":textField2.text};
        
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        NSString *str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info/login";
        
        [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [SVProgressHUD dismiss];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"dic === %@",dic);
            if ([dic[@"error"] isEqualToString:@"0"]) {
                
                UserViewController *vc = [[UserViewController alloc]init];
                vc.icon = dic[@"result"][@"icon"];
                vc.phoneNum = textField1.text;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setObject:@"1" forKey:@"isLogin"];
                [userInfo setObject:dic[@"result"][@"icon"] forKey:@"iconP"];
                [userInfo setObject:textField1.text forKey:@"phoneNum"];
                [userInfo setObject:dic[@"result"][@"token"] forKey:@"token"];
                
            }else{
            
                [SVProgressHUD showErrorWithStatus:dic[@"result"][@"data"]];
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setObject:@"0" forKey:@"isLogin"];
                [userInfo setObject:@"" forKey:@"iconP"];
                [userInfo setObject:@"" forKey:@"phoneNum"];
                [userInfo setObject:@"" forKey:@"token"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error === %@",error);
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }];
        
    }

}

//当textField编辑结束时调用的方法
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 50 &&!isBack) {
        if (![self isMobileNumber:textField.text]) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"你输入的手机号码格式不对，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
        }

    }
    
    if (textField.tag == 51) {
        UITextField *textField1 = (UITextField*)[self.view viewWithTag:50];
        UITextField *textField2 = (UITextField*)[self.view viewWithTag:51];
        if (textField1.text.length != 0 && textField2.text.length != 0) {
            UIButton *btn = (UIButton*)[self.view viewWithTag:6];
            btn.enabled = YES;
            [btn setBackgroundColor:[UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1]];
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
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];

    return YES;
    
}
-(void)registerClick:(UIButton*)btn{

    RegistViewController *registVC = [[RegistViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registVC animated:YES];
}
-(void)forgetClick:(UIButton*)btn{
    
    UITextField *textField = (UITextField*)[self.view viewWithTag:50];
    PasswordViewController *passVC = [[PasswordViewController alloc]init];
    passVC.phoneNum = textField.text;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:passVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
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
