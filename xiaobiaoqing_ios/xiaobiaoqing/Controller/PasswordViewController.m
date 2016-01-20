//
//  PasswordViewController.m
//  funnyji
//
//  Created by zhangzifei on 15/12/8.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "PasswordViewController.h"
#import "LoginViewController.h"
@interface PasswordViewController ()<UITextFieldDelegate>
{

    BOOL isBack;
}
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self initWithBackButton];
    
    
    NSArray *imageArr = [NSArray arrayWithObjects:@"lock",@"lock",@"lock", nil];
    NSArray *nameArr = [NSArray arrayWithObjects:@"原密码",@"新密码",@"确认新密码", nil];
    for (int i = 0; i < imageArr.count; i++) {
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 40+(i*(30+20)), (self.view.frame.size.width-40), 30)];
        
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = [nameArr objectAtIndex:i];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.secureTextEntry = YES;
        [self.view addSubview:textField];
        textField.tag = 50 + i;
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImageView *headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imageArr objectAtIndex:i]]];
        headImage.frame = CGRectMake(6, 3, 24, 24);
        [backView addSubview:headImage];
        textField.leftView = backView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, (self.view.frame.size.width-40), 30)];
    [btn.layer setCornerRadius:5];
    btn.tag = 6;
    btn.enabled = NO;
    [btn setTitle:@"确认修改" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)btnClick:(UIButton*)btn{

    UITextField *textField1 = (UITextField*)[self.view viewWithTag:50];
    UITextField *textField2 = (UITextField*)[self.view viewWithTag:51];
    UITextField *textField3 = (UITextField*)[self.view viewWithTag:52];
    if (textField1.text.length == 0 || textField2.text.length == 0 || textField3.text.length == 0) {
        return;
    }
    
    if (![textField2.text isEqualToString:textField3.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码输入不一致，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }else{
    
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"正在修改"];
        NSDictionary *dic = @{@"uid":_phoneNum,@"password":textField1.text,@"newpassword":textField2.text};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *str = @"http://xiaobiaoqing.gohoc.com/index.php?r=set-info/edit-user";
        [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [SVProgressHUD dismiss];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
            [SVProgressHUD showSuccessWithStatus:dic[@"result"][@"data"]];
            if ([dic[@"error"] isEqualToString:@"0"]) {
                [self performSelector:@selector(loginView) withObject:self afterDelay:1];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }];
    }
}

-(void)loginView{
    
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//当textField编辑结束时调用的方法
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    UITextField *textField1 = (UITextField*)[self.view viewWithTag:50];
    UITextField *textField2 = (UITextField*)[self.view viewWithTag:51];
    UITextField *textField3 = (UITextField*)[self.view viewWithTag:52];
    
    if (textField.tag == 51) {
        if (textField2.text.length < 6 && !isBack) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码不能少于6位，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
        }
    }else{
    
        if (textField.tag == 52) {
            
            if (![textField2.text isEqualToString:textField3.text] && !isBack) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"新密码输入不一致，请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else{
            
                if (textField1.text.length >= 6 && textField2.text.length >= 6 && textField3.text.length >= 6) {
                    UIButton *btn = (UIButton*)[self.view viewWithTag:6];
                    btn.enabled = YES;
                    [btn setBackgroundColor:[UIColor colorWithRed:138/255.0 green:192/255.0 blue:18/255.0 alpha:1]];
                }

            }
        }
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (int i = 0; i < 3; i++) {
        
        UITextField *textField = (UITextField*)[self.view viewWithTag:50+i];
        [textField resignFirstResponder];
    }
}

-(void)initWithBackButton{
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [btn setImage:[UIImage imageNamed:@"ico_back"]];
    [btn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btn;
    
}

-(void)backClick{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
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
