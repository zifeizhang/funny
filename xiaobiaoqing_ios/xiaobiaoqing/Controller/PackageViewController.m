//
//  PackageViewController.m
//  funnyji
//
//  Created by zhangzifei on 16/1/15.
//  Copyright © 2016年 com.gohoc. All rights reserved.
//

#import "PackageViewController.h"
#import "AppDelegate.h"
#import "ExpressionEntity.h"
#import "ExpressionModel.h"
#import "PackageCell.h"
#import "PackageDetailViewController.h"
@interface PackageViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UILabel *labelTips;
    UIImageView *noImageView;
}

@property(nonatomic,strong)NSMutableArray *dataSoureArr;
@property(nonatomic,strong)UITableView *userTableView;

@end

@implementation PackageViewController

-(instancetype)init{

    if (self = [super init]) {
        _dataSoureArr = [NSMutableArray array];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    
    self.userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    [self.userTableView registerNib:[UINib nibWithNibName:@"PackageCell" bundle:nil] forCellReuseIdentifier:@"PackageCell"];
    [self.view addSubview:self.userTableView];
    self.userTableView.rowHeight = 80;
    self.userTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.userTableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:245/255.0 alpha:1];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshInterface) name:@"refreshInterface" object:nil];
    [self isCollectTips];
    
}

-(void)isCollectTips{
    
    noImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-115)/2, 60, 115, 115)];
    noImageView.image = [UIImage imageNamed:@"no.jpg"];
    //noImageView.hidden = YES;
    [self.view addSubview:noImageView];
    
    labelTips = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 260)/2, 205, 260, 80)];
    labelTips.text = @"        你当前还没有收藏哦 >_<        小f已经为你准备了千万个Funny集        现在就去挑选图片和段子吧 *_* ";
    labelTips.numberOfLines = 0;
    labelTips.font = [UIFont systemFontOfSize:17];
    //labelTips.hidden = YES;
    labelTips.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [self.view addSubview:labelTips];
}


-(void)refreshInterface{

    [_dataSoureArr removeAllObjects];
    [self dataFetchRequest];
    
    if (_dataSoureArr.count > 0) {
        noImageView.hidden = YES;
        labelTips.hidden = YES;
    }else{
        
        noImageView.hidden = NO;
        labelTips.hidden = NO;
        
    }
    [self.userTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [_dataSoureArr removeAllObjects];
    
    [self dataFetchRequest];
    
    if (_dataSoureArr.count > 0) {
        noImageView.hidden = YES;
        labelTips.hidden = YES;
    }else{
        
        noImageView.hidden = NO;
        labelTips.hidden = NO;

    }
    ZFLog(@"=========%@",_dataSoureArr);
    [self.userTableView reloadData];
}
//查询全部数据
- (void)dataFetchRequest
{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"ExpressionEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:description];

    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (ExpressionEntity *info in fetchedObjects) {
        
        int isCollect = [[info valueForKey:@"isCollect"] intValue];
        
        if (isCollect == 1) {
            
            ExpressionModel *model = [[ExpressionModel alloc]init];
            
            model.expression_id = [[info valueForKey:@"expression_id"] longLongValue];
            model.name = [info valueForKey:@"name"];
            model.time_since1970 = [[info valueForKey:@"time_since1970"]longLongValue];
            model.cover_image_url = [info valueForKey:@"cover_image_url"];
            model.author = [info valueForKey:@"author"];
            model.weixin = [info valueForKey:@"weixin"];
            model.isDownload = [[info valueForKey:@"isDownload"] intValue];
            model.isCollect = [[info valueForKey:@"isCollect"] intValue];
            
            [_dataSoureArr addObject:model];
        }
    }
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSoureArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageCell" forIndexPath:indexPath];
    
    ExpressionModel *model = _dataSoureArr[indexPath.row];
   
    [cell.packageHeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.cover_image_url]]];
    cell.packageLabel.text = model.name;
    cell.authorLabel.text = [NSString stringWithFormat:@"作 者：%@",model.author];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.userTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ExpressionModel *model = _dataSoureArr[indexPath.row];
    
    PackageDetailViewController *packageDetailVC = [[PackageDetailViewController alloc]init];
    
    packageDetailVC.model = model;
    [self presentViewController:packageDetailVC animated:YES completion:nil];
}


-(void)dealloc{

   
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
