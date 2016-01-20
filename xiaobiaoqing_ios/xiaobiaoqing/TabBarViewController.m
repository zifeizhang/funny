//
//  TabBarViewController.m
//  微博
//
//  Created by xinguo016 on 15/8/7.
//  Copyright (c) 2015年 xinguo2015. All rights reserved.
//

#import "TabBarViewController.h"
#import "xiaobiaoqing-Prefix.pch"
#import "CollectViewController.h"
#import "ExpressionViewController.h"
#import "PictureViewController.h"
#import "JokeViewController.h"



@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ExpressionViewController *message=[[ExpressionViewController alloc]init];
    [self addChildVc:message WithTitile:@"表情大全" image:@"tab_biaoqing" selectedImage:@"tab_biaoqing_on"];
    PictureViewController *discover=[[PictureViewController alloc]init];
    [self addChildVc:discover WithTitile:@"动态图片" image:@"tab_dongtai" selectedImage:@"tab_dongtai_on"];
    JokeViewController *profile=[[JokeViewController alloc]init];
    [self addChildVc:profile WithTitile:@"内涵段子" image:@"tab_duanzi" selectedImage:@"tab_duanzi_on"];
    CollectViewController *home=[[CollectViewController alloc]init];
    [self addChildVc:home WithTitile:@"我的收藏" image:@"tab_shoucang" selectedImage:@"tab_shoucang_on"];
}

-(void)addChildVc:(UIViewController*)childVc WithTitile:(NSString*)title image:(NSString*)image selectedImage:(NSString*)selectedImage{
    
//    childVc.tabBarItem.title=title;
//    childVc.navigationItem.title = title;
//    childVc.view.backgroundColor=WBRandom;
    
    
    childVc.title = title;
    
    childVc.tabBarItem.image=[UIImage imageNamed:image];
    
    childVc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    
    textAttrs[NSForegroundColorAttributeName]=WBTextAttrsColor;
    
    NSMutableDictionary *selectedTextAttrs=[NSMutableDictionary dictionary];
    
    selectedTextAttrs[NSForegroundColorAttributeName]=[UIColor colorWithRed:141/255.0 green:191/255.0 blue:0/255.0 alpha:1];
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
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
