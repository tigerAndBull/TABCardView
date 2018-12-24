//
//  CardView.h
//  TABCardProject
//
//  Created by tigerAndBull on 2018/12/17.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardView.h"
#import "TABBaseCardView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CardViewBlock)(void);

@interface CardView : TABBaseCardView

@property (nonatomic,strong) UIImageView * cardImg;
@property (nonatomic,strong) UIButton * cardBtn;

@property (nonatomic) CardViewBlock clickBlock;

- (void)updateViewWithData:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
