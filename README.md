## 本文目录

> + 效果图
> + 使用方法
> + 实现说明

## 效果图

![效果图.gif](https://upload-images.jianshu.io/upload_images/5632003-1063fefc1b7a2b96.gif?imageMogr2/auto-orient/strip)

## 使用方法
**1. install**
> pod search TABCardView

**2. 初始化**
```
/**
 初始化方法

 @param frame 位置
 @param showCardsNumber 显示的卡片数
 @return TABCardView's object
 */
- (instancetype)initWithFrame:(CGRect)frame
              showCardsNumber:(NSInteger)showCardsNumber;
```
```
// 简单使用示例
self.cardView = [[TABCardView alloc] initWithFrame:CGRectMake(40, (kScreenHeight - 320)/2, kScreenWidth - 120, 320)
                                       showCardsNumber:4];
self.cardView.isShowNoDataView = YES;
self.cardView.noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"占位图"]];
self.cardView.delegate = self;
[self.view addSubview:self.cardView];
```
3. 刷新数据源
```
// 使用示例
[self.cardView loadCardViewWithData:array];
```
4. 参数说明
>1. `showCardsNumber` 需要展示的卡片数
>2. `isShowNoDataView` 是否在没有数据时，显示卡片
>3. `noDataView` 没有数据时，显示的view
>4. `offsetX` 展示卡片的横坐标偏移量，默认为20，决定卡片堆叠方式
>5. `offsetY` 展示卡片的纵坐标偏移量，默认为0，决定卡片堆叠方式

## 说明
>1. 卡片组是一个view
>2. 卡片组由多个TABBaseCardView组成，你可以继承TABBaseCardView，定制自己的卡片内容，不只是一张图
>3. 代理目前的作用是：告诉你当前是哪个卡片

## 最后
>1. github地址（有demo）：https://github.com/tigerAndBull/TABCardView
>2. 欢迎评论交流，后续有新的需求，会继续改进！
>3. 自推 -> 原生骨架屏地址：https://www.jianshu.com/p/6a0ca4995dff
>4. 私人wx：awh199833
