//
//  ExpressionViewCell.m
//  xiaobiaoqing
//
//  Created by zhangzifei on 15/10/28.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "ExpressionViewCell.h"
#import "ExpressionModel.h"

//#import "ExpressionDetailModel.h"
//#define expression_url  @"http://xiaobiaoqing.gohoc.com/index.php?r=list1/icon-base1all&id=%ld"

@interface ExpressionViewCell ()
{

//    float progress;
}

@end
@implementation ExpressionViewCell

- (void)awakeFromNib {
    
}


-(ExpressionViewCell*)cellWithData:(ExpressionModel*)model{
    
    _selfModel = model;
    
    self.nameLabel.text = model.name;
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@",model.author];
    self.authorLabel.textColor = [UIColor colorWithRed:144/255.0 green:146/255.0 blue:147/255.0 alpha:1];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.cover_image_url]] placeholderImage:[UIImage imageNamed:@"hourglass"]];
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, 60, 25);
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 5;
        _btn.enabled = NO;
        _btn.layer.borderWidth = 0.5;
        _btn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:206/255.0 blue:59/255.0 alpha:1].CGColor;
        _btn.tag =(int)model.expression_id;

    }
    _btn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_btn addTarget:self action:@selector(downLoadBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = _btn;
    
    if (!_progressView) {
        
        _progressView = [[ZFProgressView alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
        [_progressView setProgressViewStyle:UIProgressViewStyleDefault];
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 25.0f);
        _progressView.transform = transform;
        
        _progressView.progress = 0.0;
        
    }
    _progressView.hidden = YES;
    _progressView.trackTintColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    _progressView.progressTintColor = [UIColor colorWithRed:34/255.0 green:206/255.0 blue:59/255.0 alpha:1];
    [_btn addSubview:_progressView];
    
    
    if (model.isDownload == 1) {
        
        self.btn.userInteractionEnabled = NO;
        [self.btn setTitleColor:[UIColor colorWithRed:144/255.0 green:146/255.0 blue:147/255.0 alpha:1] forState:UIControlStateNormal];
        self.btn.layer.borderColor = [UIColor colorWithRed:144/255.0 green:146/255.0 blue:147/255.0 alpha:1].CGColor;
        [self.btn setTitle:@"已下载" forState:UIControlStateNormal];
        
    }
    else if(model.isDownload == 2){
        
        self.btn.userInteractionEnabled = YES;
        [self.btn setTitleColor:[UIColor colorWithRed:34/255.0 green:206/255.0 blue:59/255.0 alpha:1] forState:UIControlStateNormal];
        self.btn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:206/255.0 blue:59/255.0 alpha:1].CGColor;
        [self.btn setTitle:@"已暂停" forState:UIControlStateNormal];
        
    }
    else if(model.isDownload == 0){
        self.btn.userInteractionEnabled = YES;
        [self.btn setTitleColor:[UIColor colorWithRed:34/255.0 green:206/255.0 blue:59/255.0 alpha:1] forState:UIControlStateNormal];
        self.btn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:206/255.0 blue:59/255.0 alpha:1].CGColor;
        [self.btn setTitle:@"下载" forState:UIControlStateNormal];
    }else{
    
        self.progressView.hidden = NO;
    }

    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}






/*
- (void)downLoadBtn:(UIButton *)sender {
    
    self.userInteractionEnabled = NO;
    sender.userInteractionEnabled = NO;
    [_progressView setProgress:progress animated:YES];
    _progressView.hidden = NO;
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    _imagePath1 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_imagePath1])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:_imagePath1 withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹

    }
    
    [self getDataUrl:[NSString stringWithFormat:expression_url,(long)sender.tag] tag:sender.tag];

}

-(void)getDataUrl:(NSString*)Url tag:(NSInteger)tag{
    
  
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        [self parsJSON:dic tag:tag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
}

//解析数据
-(void)parsJSON:(NSDictionary*)dic tag:(NSInteger)tag{
    
    dispatch_queue_t queue = dispatch_queue_create("tupianxiazai", nil);
    dispatch_async(queue, ^{
        
        @synchronized(self) {
            _count = [dic[@"result"][@"count"] integerValue];
            for (NSDictionary *dic1 in dic[@"result"][@"data"]) {
                
                ExpressionDetailModel *model = [[ExpressionDetailModel alloc]init];
                //model.name = dic1[@"name"];
                model.image_url = dic1[@"image_url"];
                //model.time_since1970 = [dic1[@"time_since1970"] longLongValue];
                model.image_id = [dic1[@"image_id"] longLongValue];
                
                [self downloadImage:model tag:tag];
            }
        }
        
    });
}
-(void)downloadImage:(ExpressionDetailModel*)model tag:(NSInteger)tag{
            
    @synchronized(self) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://xiaobiaoqing.gohoc.com/%@",model.image_url]]];
        NSString *imagePath = [_imagePath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",model.image_id]];
        [data writeToFile:imagePath atomically:YES];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            _total++;
            
            progress = _total*1.0/_count;
            [_progressView setProgress:progress animated:YES];
            
            if (_total == _count) {
                _total = 0;
                progress = 0;
                [self.progressView setProgress:progress animated:YES];
                _progressView.hidden = YES;
                self.userInteractionEnabled = YES;
                _btn.userInteractionEnabled = NO;
                
                [_btn setTitleColor:[UIColor colorWithRed:144/255.0 green:146/255.0 blue:147/255.0 alpha:1] forState:UIControlStateNormal];
                _btn.layer.borderColor = [UIColor colorWithRed:144/255.0 green:146/255.0 blue:147/255.0 alpha:1].CGColor;
                [_btn setTitle:@"已下载" forState:UIControlStateNormal];
                
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setObject:[NSString stringWithFormat:@"1"] forKey:[NSString stringWithFormat:@"expression_id%ld",(long)tag]];
            }
            
        });

    }
}
*/


@end
