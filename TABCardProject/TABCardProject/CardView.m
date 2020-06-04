//
//  CardView.m
//  TABCardProject
//
//  Created by tigerAndBull on 2018/12/17.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        {
            UIImageView *img = [[UIImageView alloc] init];
            img.contentMode = UIViewContentModeScaleAspectFill;
            _cardImg = img;
            [self addSubview:img];
        }
        
        {
            UIButton *btn = [[UIButton alloc] init];
            [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundColor:[UIColor clearColor]];
            
            _cardBtn = btn;
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cardImg.frame = self.bounds;
    _cardBtn.frame = self.bounds;
}

- (void)updateViewWithData:(NSString *)imageUrl {
    [_cardImg setImage:[UIImage imageNamed:imageUrl]];
}

- (void)action {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
