//
//  TABCardView.h
//  TABCardProject
//
//  Created by tigerAndBull on 2018/12/17.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABBaseCardView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TABCardViewDelegate <NSObject>

@optional
- (void)tabCardViewCurrentIndex:(NSInteger)index;

@end

@interface TABCardView : UIView

// 卡片内容数组
@property (nonatomic, strong, readonly, nonnull) NSMutableArray <TABBaseCardView *> * cards;
// default is 10.0.
@property (nonatomic) CGFloat cardCornerRadius;
// 是否展示无数据占位view
@property (nonatomic) BOOL isShowNoDataView;
// 无数据占位图
@property (nonatomic, strong) UIView * noDataView;
// 展示卡片的横坐标偏移量
@property (nonatomic) CGFloat    offsetX;
// 展示卡片的纵坐标偏移量
@property (nonatomic) CGFloat    offsetY;

@property (nonatomic, weak) id <TABCardViewDelegate> delegate;

/**
 初始化方法

 @param frame 位置
 @param showCardsNumber 显示的卡片数
 @return TABCardView's object
 */
- (instancetype)initWithFrame:(CGRect)frame showCardsNumber:(NSInteger)showCardsNumber;

- (void)loadCardViewWithData:(NSMutableArray <TABBaseCardView *> *)cards;

@end

NS_ASSUME_NONNULL_END
