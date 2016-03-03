//
//  XMNShareView.h
//  XMNShareMenuExample
//
//  Created by XMFraker on 16/1/25.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XMNSelectedBlock)(NSUInteger tag,NSString *title);

@interface XMNShareView : UIView

/**
 *  shareContentView的头部view 默认nil
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *  shareContentView的底部view  默认nil
 */
@property (nonatomic, strong) UIView *footerView;

/** 默认每行显示的数量 最多两行超过的均在第二行显示  默认9  */
@property (nonatomic, assign) NSUInteger itemsPerLine;

@property (nonatomic, copy)   void(^selectedBlock)(NSUInteger tag, NSString *title);


//  分享标题
@property (nonatomic, strong) NSString *shareTitle;

//  分享文本
@property (nonatomic, strong) NSString *shareText;

//  分享链接
@property (nonatomic, strong) NSString *shareUrl;

/**
 *  显示shareView
 *
 *  @param animated 是否使用动画
 */
- (void)showUseAnimated:(BOOL)animated;

/**
 *  隐藏shareView
 *
 *  @param animated 是否使用动画
 */
- (void)dismissUseAnimated:(BOOL)animated;

/**
 *  初始化shareView
 *
 *  @param items 需要显示的item的array
 */
- (void)setupShareViewWithItems:(NSArray *)items;

@end
