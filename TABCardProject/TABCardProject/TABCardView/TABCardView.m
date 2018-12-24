//
//  TABCardView.m
//  TABCardProject
//
//  Created by tigerAndBull on 2018/12/17.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABBaseCardView.h"
#import "TABCardView.h"

#import "TABDefine.h"

static NSString * tabCardNoDataString = @"TABCARDNODATASTRING";

@interface TABCardView (){
    
    __strong TABBaseCardView * tempView;
    float sizePercent;                                                  // 顶部卡片拖动中，底部卡片缩放系数
}

@property (nonatomic,strong,readonly) NSMutableArray * alphaArray;      // 可视卡片透明度数组
@property (nonatomic,strong) UIPanGestureRecognizer  * cardPan;

@property (nonatomic) NSInteger  showCardsNumber;                       // 展示的卡片数
@property (nonatomic) NSInteger  currentIndex;                          // 当前index
@property (nonatomic) CGPoint    oldCenter;

@property (nonatomic) NSInteger  cardCount;                             // 卡片总量

@end

@implementation TABCardView

- (instancetype)initWithFrame:(CGRect)frame
              showCardsNumber:(NSInteger)showCardsNumber {
    
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        sizePercent = 0.05;
        self.showCardsNumber = showCardsNumber;
    }
    return self;
}

#pragma mark - Target Methods

- (void)panHandle:(UIPanGestureRecognizer *)pan {
    
    // 获取顶部视图
    TABBaseCardView * cardView = self.cards[self.currentIndex];
    
    CGPoint velocity = [pan velocityInView:[UIApplication sharedApplication].keyWindow];
    
    // 开始拖动
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 缓存卡片最初的位置信息
        self.oldCenter = cardView.center;
    }
    
    // 拖动中
    {
        // 给顶部视图添加动画
        CGPoint transLcation = [pan translationInView:cardView];
        // 视图跟随手势移动
        cardView.center = CGPointMake(cardView.center.x + transLcation.x, cardView.center.y + transLcation.y);
        // 计算偏移系数
        CGFloat XOffPercent = (cardView.center.x - self.center.x)/(self.center.x);
        CGFloat rotation = M_PI_2/10.5*XOffPercent;
        cardView.transform = CGAffineTransformMakeRotation(-rotation);
        [pan setTranslation:CGPointZero inView:cardView];
        // 给其余底部视图添加缩放动画
        [self animationBlowViewWithXOffPercent:fabs(XOffPercent)];
    }
    
    // 拖动结束
    if (pan.state == UIGestureRecognizerStateEnded) {

        // 移除拖动视图逻辑
        
        // 加速度 小于 1100points/second
        if (sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) < 1100.0) {
            
            // 移动区域半径大于120pt
            if ((sqrt(pow(self.oldCenter.x-cardView.center.x,2) + pow(self.oldCenter.y-cardView.center.y,2))) > 120) {
                
                // 移除，自然垂落
                [UIView animateWithDuration:0.6 animations:^{
                    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
                    CGRect rect = [cardView convertRect:cardView.bounds toView:window];
                    cardView.center = CGPointMake(cardView.center.x, cardView.center.y+(kScreenHeight-rect.origin.y+50));
                }];
                [self animationBlowViewWithXOffPercent:1];
                [self performSelector:@selector(cardRemove:) withObject:cardView afterDelay:0.5];
                
            }else {
                
                __weak typeof(self) weakSelf = self;
                // 不移除，回到初始位置
                [UIView animateWithDuration:0.5 animations:^{
                    cardView.center = weakSelf.oldCenter;
                    cardView.transform = CGAffineTransformMakeRotation(0);
                    [self animationBlowViewWithXOffPercent:0];
                }];
            }
        }else {
            
            // 移除，以手势速度飞出
            [UIView animateWithDuration:0.5 animations:^{
                cardView.center = velocity;
            }];
            [self animationBlowViewWithXOffPercent:1];
            [self performSelector:@selector(cardRemove:) withObject:cardView afterDelay:0.25];
        }
    }
}

- (void)cardRemove:(TABBaseCardView *)card {
    
    if (card) {
        [card removeGestureRecognizer:self.cardPan];
        [card removeFromSuperview];
    }
    
    self.currentIndex --;
    if ((NSInteger)self.currentIndex < 0) {
        self.currentIndex = self.cardCount - 1;
    }
    
    [self addPanGestureWithView:self.cards[self.currentIndex]];
    [self addNewCard];
}

#pragma mark - Public Methods

- (void)loadCardViewWithData:(NSMutableArray<TABBaseCardView *> *)cards {
    
    if (nil == cards) {
        NSLog(@"卡片数据源为nil");
        return;
    }
    
    if (self.showCardsNumber == 0) {
        NSLog(@"未设置显示卡片数，将使用默认值：4");
        self.showCardsNumber = 4;
    }
    
    if (cards) {
        NSLog(@"重新设置数据源，移除旧视图");
        if (self.subviews.count > 0) {
            for (UIView *subV in self.subviews) {
                if ([subV isKindOfClass:[TABBaseCardView class]] ||
                    [subV.layer.name isEqualToString:tabCardNoDataString]) {
                    [subV removeFromSuperview];
                }
            }
        }
    }
    
    _cards = cards;
    self.cardCount = cards.count;
    
    for (int i = 0; i < self.cardCount; i++) {
        TABBaseCardView * cardView = _cards[i];
        cardView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        // 位置偏移
        cardView.center = CGPointMake(self.center.x + self.offsetX*(self.cardCount-1-i) - self.frame.origin.x, self.center.y + self.offsetY*(self.cardCount-1-i) - self.frame.origin.y);
        // 缩放效果
        cardView.transform = CGAffineTransformMakeScale(1-sizePercent*(self.cardCount-i-1), 1-sizePercent*(self.cardCount-i-1));
        cardView.layer.cornerRadius = self.cardCornerRadius;
        cardView.layer.masksToBounds = YES;
        cardView.backgroundColor = [UIColor clearColor];
        NSLog(@"%lf",cardView.frame.size.width);
    }
    
    [self addCardViewsToShow];
}

#pragma mark - Private Methods

- (void)addNewCard {
    
    // 添加一个视图
    if ((int)(self.currentIndex-_showCardsNumber+1) >= 0) {
        
        TABBaseCardView *cardView = self.cards[self.currentIndex-_showCardsNumber+1];
        cardView.center = CGPointMake(self.center.x + self.offsetX*(_showCardsNumber-1) - self.frame.origin.x, self.center.y + self.offsetY*(_showCardsNumber-1) - self.frame.origin.y);
        cardView.transform = CGAffineTransformMakeScale(1-sizePercent*(_showCardsNumber-1), 1-sizePercent*(_showCardsNumber-1));
        cardView.alpha = 0;
        [self addSubview:cardView];
        [self insertSubview:cardView belowSubview:self.cards[self.currentIndex-_showCardsNumber+2]];
        
        tempView = cardView;
    }else {
        
        NSInteger index = self.cardCount + (self.currentIndex-_showCardsNumber+1);
        TABBaseCardView *cardView = self.cards[index];
        cardView.center = CGPointMake(self.center.x + self.offsetX*(_showCardsNumber-1) - self.frame.origin.x, self.center.y + self.offsetY*(_showCardsNumber-1) - self.frame.origin.y);
        cardView.transform = CGAffineTransformMakeScale(1-sizePercent*(_showCardsNumber-1), 1-sizePercent*(_showCardsNumber-1));
        cardView.alpha = 0;
        [self addSubview:cardView];
        [self insertSubview:cardView belowSubview:tempView];
        
        tempView = cardView;
    }
    
    if (self.delegate) {
        [self.delegate tabCardViewCurrentIndex:self.currentIndex];
    }
}

- (void)addCardViewsToShow {
    
    if (nil == self.cards || 0 == self.cards.count) {
        
        if (self.isShowNoDataView) {

            for (int i = 0; i < _showCardsNumber; i++) {
                
                UIView * cardView = [[UIView alloc] init];
                cardView.backgroundColor = [UIColor whiteColor];
                if (self.noDataView) {
                    [cardView addSubview:self.noDataView];
                }
                cardView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                // 位置偏移
                cardView.center = CGPointMake(self.center.x + self.offsetX*(_showCardsNumber-1-i) - self.frame.origin.x, self.center.y + self.offsetY*(_showCardsNumber-1-i) - self.frame.origin.y);
                // 缩放效果
                cardView.transform = CGAffineTransformMakeScale(1-sizePercent*(_showCardsNumber-i-1), 1-sizePercent*(_showCardsNumber-i-1));
                cardView.layer.cornerRadius = self.cardCornerRadius;
                cardView.layer.masksToBounds = YES;
                cardView.alpha = [self.alphaArray[i] floatValue];
                cardView.layer.name = tabCardNoDataString;
                
                [self addSubview:cardView];
            }
        }
    }else {
        
        if (self.cardCount < _showCardsNumber) {
            
            NSLog(@"卡片数少于显示数，显示数赋值为卡片数");
            NSInteger removeNum = _showCardsNumber - self.cardCount;
            _showCardsNumber = self.cardCount;
            
            for (int i = 0; i < removeNum; i++) {
                [self.alphaArray removeObjectAtIndex:0];
            }
            
            for (int i = 0; i < _showCardsNumber; i++) {
                TABBaseCardView * cardView = self.cards[i];
                cardView.alpha = [self.alphaArray[i] floatValue];
                [self addSubview:cardView];
                if (i == _showCardsNumber - 1) {
                    [self addPanGestureWithView:cardView];
                    self.currentIndex = _showCardsNumber - 1;
                }
            }
        }else {
            
            for (int i = 0; i < _showCardsNumber; i++) {
                TABBaseCardView * cardView = self.cards[self.cardCount-_showCardsNumber+i];
                cardView.alpha = [self.alphaArray[i] floatValue];
                [self addSubview:cardView];
                if (i == _showCardsNumber - 1) {
                    [self addPanGestureWithView:cardView];
                    self.currentIndex = self.cardCount - 1;
                }
            }
        }
    }
}

// 视图上的卡片 偏移缩放
- (void)animationBlowViewWithXOffPercent:(CGFloat)XOffPercent {

    for (int i = 0; i < _showCardsNumber - 1; i++) {
        
        NSInteger index = self.currentIndex - i - 1;
        if (index < 0) {
            index = self.cardCount + index;
        }
        
        TABBaseCardView * otherView = self.cards[index];
        // 透明度
        CGFloat alpha = [self.alphaArray[_showCardsNumber - i - 2] floatValue] + ([self.alphaArray[_showCardsNumber - i - 1] floatValue] - [self.alphaArray[_showCardsNumber - i - 2] floatValue])*XOffPercent;
        otherView.alpha = alpha;
        // 中心
        CGPoint point = CGPointMake(self.center.x + self.offsetX*(i + 1) - self.offsetX*XOffPercent - self.frame.origin.x, self.center.y + self.offsetY*(i + 1) - self.offsetY*XOffPercent - self.frame.origin.y);
        otherView.center = point;
        // 缩放大小
        CGFloat scale = 1 - sizePercent * (i + 1) + XOffPercent * sizePercent;
        otherView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)addPanGestureWithView:(TABBaseCardView *)cardView {
    // 添加拖动手势
    [cardView addGestureRecognizer:self.cardPan];
}

#pragma mark - Getter / Setter

@synthesize alphaArray = _alphaArray;
- (NSMutableArray *)alphaArray {
    
    NSMutableArray *array = [NSMutableArray array];
    float interval = (self.showCardsNumber - 1)/10.0;
    
    for (int i = 0; i < self.showCardsNumber; i++) {
        if (i == 0) {
            [array addObject:@(0.0)];
            continue;
        }
        if (i == self.showCardsNumber - 1) {
            [array addObject:@(1.0)];
            break;
        }
        [array addObject:@(i*interval + 0.2)];
    }
    return _alphaArray = array;
}

@synthesize cards = _cards;
- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (void)setShowCardsNumber:(NSInteger)showCardsNumber {
    _showCardsNumber = (showCardsNumber > 0)?showCardsNumber:4;
    [self alphaArray];
}

- (CGFloat)cardCornerRadius {
    if (_cardCornerRadius == 0.0) {
        return 10.0;
    }
    return _cardCornerRadius;
}

- (CGFloat)offsetX {
    if (_offsetX == 0.0) {
        return 20.0;
    }
    return _offsetX;
}

- (NSInteger)cardCount {
    if (!self.cards) {
        return 0;
    }
    _cardCount = self.cards.count;
    return _cardCount;
}

- (void)setIsShowNoDataView:(BOOL)isShowNoDataView {
    _isShowNoDataView = isShowNoDataView;
    
    if (isShowNoDataView) {
        [self addCardViewsToShow];
    }
}

- (void)setNoDataView:(UIView *)noDataView {
    _noDataView = noDataView;
    
    if (self.isShowNoDataView) {
        for (int i = 0; i < self.subviews.count; i++) {
            UIView *subV = self.subviews[i];
            if ([subV.layer.name isEqualToString:tabCardNoDataString]) {
                [subV addSubview:noDataView];
            }
        }
    }
}

- (UIPanGestureRecognizer *)cardPan {
    if (!_cardPan) {
        _cardPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
    }
    return _cardPan;
}

@end
