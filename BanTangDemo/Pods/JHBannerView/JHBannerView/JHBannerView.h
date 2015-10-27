//
//  JHBannerView.h
//  JHBannerView
//
//  Created by Tony Stark on 15/8/28.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHBannerView;


typedef enum : NSInteger {
    JHBannerViewPageControlAlignmentTypeLeft = -1,   // 左对齐
    JHBannerViewPageControlAlignmentTypeCenter = 0,  // 居中
    JHBannerViewPageControlAlignmentTypeRight = 1,   // 右对齐
} JHBannerViewPageControlAlignmentType;

@protocol JHBannerViewDelegate <NSObject>
@optional
/** 图片切换时调用 */
- (void)bannerViewPictureDidChanged:(JHBannerView *)bannerView;
/** 用户点击时调用 */
- (void)bannerView:(JHBannerView *)bannerView didPictureClickedAtIndex:(NSInteger)index;
/** 用户拖动时调用 */
- (void)bannerViewPictureDidDragByUser:(JHBannerView *)bannerView;

@end

@interface JHBannerView : UIView
/** 存放所有图片 */
@property (nonatomic, strong)NSArray *images;
/** 占位图 */
@property (nonatomic, strong)UIImage *placeholder;
/** 轮播时间 */
@property (nonatomic, assign)NSTimeInterval timeInterval;
/** 对齐方式 */
@property (nonatomic, assign)JHBannerViewPageControlAlignmentType alignment;
/** 是否隐藏pageControl */
@property (nonatomic, assign)BOOL pageControlHidden;
/** 图片排版模式 */
@property (nonatomic, assign)UIViewContentMode bannerViewContentMode;
/** sessionConfig */
@property (nonatomic, strong)NSURLSessionConfiguration *config;
/** 代理 */
@property (nonatomic, weak)id<JHBannerViewDelegate>delegate;
/** 当前显示页码 */
@property (nonatomic, assign)NSInteger currentPage;

- (void)setImagesAndResetCurrentPage:(NSArray *)images;

#pragma mark 工厂方法
+ (instancetype)bannerViewWithImages:(NSArray *)image;

+ (instancetype)bannerViewWithFrame:(CGRect)frame andImages:(NSArray *)images;

+ (instancetype)bannerViewWithFrame:(CGRect)frame images:(NSArray *)images timeInterval:(NSTimeInterval)timeInterval alignment:(JHBannerViewPageControlAlignmentType)alignment;

@end



