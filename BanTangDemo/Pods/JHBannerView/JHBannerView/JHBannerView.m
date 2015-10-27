//
//  JHBannerView.m
//  JHBannerView
//
//  Created by Tony Stark on 15/8/28.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

/**
 *  1. 传入的数据源类型可以是UIImage和NSString(图片url)混合数组
 *  2. 已建立缓存机制防止多次传入相同的url导致图片的重复下载
 *  3. 遵守JHBannerViewDelegate就可以监听JHBannerView的状态切换
 *  4. 部分属性通过下面的属性宏修改
 *  5. 若无指定frame,控件会根据父控件自动设置自己的frame
 *  6. 等等..
 */


#import "JHBannerView.h"


// 属性宏
#define defaultTimeInterval         5
#define defaultPageSelectedColor    [UIColor whiteColor]    // 选择点的颜色
#define defaultPageTinyColor        [UIColor grayColor]     // 非选择点的颜色

// 简便宏
#define imageViewArr(k) ((UIImageView *)self.imageViews[k])
#define ifDelegateRespone(st) if (_delegate && [_delegate respondsToSelector:@selector(st)])

@interface JHBannerView ()<UIScrollViewDelegate>

/** bannerView */
@property (nonatomic, weak)UIScrollView *bannerView;

/** 页数控制器 */
@property (nonatomic, weak)UIPageControl *pageControl;

/** 缓存,只保存通过网络下载的图片(URL -> UIImage) */
@property (nonatomic, strong)NSMutableDictionary *cacheDict;

/** 展示的imageViews(3个) */
@property (nonatomic, strong)NSArray *imageViews;

/** 翻页定时器 */
@property (nonatomic, strong)NSTimer *timer;

/** 内部处理的images */
@property (nonatomic, strong)NSMutableArray *privateImages;

/** 更新时间记录 */
@property (nonatomic, strong)NSDate *lastUpdate;

/** 是否处于交互状态 */
@property (nonatomic, assign)BOOL isDragByUser;

@end

@implementation JHBannerView
@synthesize privateImages = _privateImages;

+ (instancetype)bannerViewWithImages:(NSMutableArray *)image {
    JHBannerView *bannerView = [JHBannerView bannerViewWithFrame:CGRectZero andImages:image];
    return bannerView;
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame andImages:(NSMutableArray *)images {
    JHBannerView *bannerView = [[JHBannerView alloc] initWithFrame:frame];
    bannerView.images = images;
    return bannerView;
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame images:(NSMutableArray *)images timeInterval:(NSTimeInterval)timeInterval alignment:(JHBannerViewPageControlAlignmentType)alignment {
    JHBannerView *bannerView = [JHBannerView bannerViewWithFrame:frame andImages:images];
    bannerView.timeInterval = timeInterval;
    bannerView.alignment = alignment;
    return bannerView;
}

// 初始化操作
- (void)setupWhenInit {
    self.bannerView.pagingEnabled = YES;
    self.bannerView.showsHorizontalScrollIndicator = NO;
    self.bannerView.showsVerticalScrollIndicator = NO;
    self.bannerView.delegate = self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupWhenInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupWhenInit];
    }
    return self;
}

- (void)startTimer {
    [self stopTimer];
    CGFloat interVal = self.timeInterval;
    if (interVal < 0.1) {
        interVal = defaultTimeInterval;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interVal target:self selector:@selector(scrollByTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark 布局相关方法
- (void)setupPageControlWhenLayout {
    CGFloat width = self.frame.size.width;
    self.pageControl.center = CGPointMake(0.5 * width * (1 + self.alignment) - self.alignment * width * 0.1, self.frame.size.height * 0.92);
}

- (void)setupImageViewsWhenLayout {
    CGRect rect = self.bounds;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.imageViews[i];
        rect.origin.x = rect.size.width * i;
        imageView.frame = rect;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    if (width <= 1) {// 如果没有接受到frame就强制赋值
        width = self.superview.frame.size.width;
        CGFloat height = width * 0.0625 * 9;
        height = height > self.superview.frame.size.height ? self.superview.frame.size.height : height;
        CGRect rect = CGRectMake(0, 0, width, height);
        self.frame = rect;
    }
    // 调整scrollView
    self.bannerView.frame = self.bounds;
    self.bannerView.contentSize = CGSizeMake(width * 3, 0);
    self.bannerView.contentOffset = CGPointMake(width, 0);
    [self setupPageControlWhenLayout];
    [self setupImageViewsWhenLayout];
}

#pragma mark set方法
- (void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage < self.pageControl.numberOfPages) {
        self.pageControl.currentPage = currentPage;
        [self reloadImageViewsImage];
    }
}

- (void)setBannerViewContentMode:(UIViewContentMode)bannerViewContentMode {
    for (UIImageView *iv in self.imageViews) {
        iv.contentMode = bannerViewContentMode;
    }
}

- (void)setAlignment:(JHBannerViewPageControlAlignmentType)alignment {
    _alignment = alignment;
    [self setupPageControlWhenLayout];
}

/** 用于修改了timeInterval的时候重设定时器 */
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    [self startTimer];
}

- (void)setPageControlHidden:(BOOL)pageControlHidden {
    self.pageControl.hidden = pageControlHidden;
}

- (void)setImagesAndResetCurrentPage:(NSArray *)images {
    self.pageControl.currentPage = 0;
    [self setImages:images];
}

- (void)setImages:(NSArray *)images {
    NSMutableArray *urls = [NSMutableArray array];
    // 如果不是UIImage或NSString类型则抛异常
    for (NSObject *ob in images) {
        if ([ob isKindOfClass:[NSString class]]) {
            NSString *url = (NSString *)ob;
            [urls addObject:url];
        } else if (![ob isKindOfClass:[UIImage class]]) {
            NSException *exception = [NSException exceptionWithName:@"Exception in JHBannerViewError" reason:@"请不要传入非UIImage和NSString类型以外的对象" userInfo:nil];
            @throw exception;
        }
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:images];
    // 剔除缓存中不需要的image
    if ((self.cacheDict.count > 1) && (urls.count > 1)) {
        NSSet *urlSet = [NSSet setWithArray:urls];
        NSMutableSet *cacheSet = [NSMutableSet setWithArray:self.cacheDict.allKeys];
        [cacheSet minusSet:urlSet];
        for (NSString *urlKey in cacheSet) {
            self.cacheDict[urlKey] = nil;
        }
    }
    if (!self.timer && images.count > 1) {
        [self startTimer];
    }
    self.privateImages = temp;
}

- (void)setPrivateImages:(NSMutableArray *)privateImages {
    self.lastUpdate = [NSDate date];
    _privateImages = privateImages;
    BOOL isMoreThanOne = _privateImages.count > 1;
    self.bannerView.scrollEnabled = isMoreThanOne;
    self.pageControl.hidden = !isMoreThanOne;
    self.pageControl.numberOfPages = _privateImages.count;
    [self reloadImageViewsImage];
}

#pragma mark get方法
- (NSInteger)currentPage {
    return self.pageControl.currentPage;
}

//- (NSTimeInterval)timeInterval {
//    return self.timer.timeInterval;
//}

- (UIViewContentMode)bannerViewContentMode {
    return imageViewArr(0).contentMode;
}

- (BOOL)pageControlHidden {
    return self.pageControl.hidden;
}

- (NSArray *)images {
    return [NSArray arrayWithArray:self.privateImages];
}

- (NSURLSessionConfiguration *)config {
    if (!_config) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _config;
}

- (NSMutableDictionary *)cacheDict {
    if (!_cacheDict) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
}

- (UIScrollView *)bannerView {
    if (!_bannerView) {
        UIScrollView *temp = [[UIScrollView alloc] init];
        _bannerView = temp;
        [self addSubview:_bannerView];
    }
    return _bannerView;
}

- (NSArray *)imageViews {
    if (!_imageViews) {
        NSMutableArray *tempImageViews = [NSMutableArray array];
        // 初始化三个imageView
        for (NSInteger i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.bannerView insertSubview:imageView atIndex:0];
            [tempImageViews addObject:imageView];
            // 为imageView添加点击响应
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked)];
            [imageView addGestureRecognizer:tap];
        }
        _imageViews = tempImageViews;
    }
    return _imageViews;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        _pageControl = pageControl;
        _pageControl.currentPageIndicatorTintColor = defaultPageSelectedColor;
        _pageControl.tintColor = defaultPageTinyColor;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (NSMutableArray *)privateImages {
    if (!_privateImages) {
        [NSMutableArray array];
    }
    return _privateImages;
}

/** 计算上一页 */
- (NSInteger)prePage {
    return ((self.pageControl.currentPage == 0) ? (self.images.count - 1) : (self.pageControl.currentPage - 1));
}

/** 计算下一页 */
- (NSInteger)nextPage {
    return ((self.pageControl.currentPage == (self.images.count - 1)) ? 0 : (self.pageControl.currentPage + 1));
}

- (void)imageViewClicked {
    ifDelegateRespone(bannerView:didPictureClickedAtIndex:) {
        [_delegate bannerView:self didPictureClickedAtIndex:self.pageControl.currentPage];
    }
}

- (void)reloadAfterDownloadForIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (index == self.pageControl.currentPage) {
            imageViewArr(1).image = [self getImageForIndex:index];
            return;
        }
        if (index == [self prePage]) {
            imageViewArr(0).image = [self getImageForIndex:index];
        }
        if (index == [self nextPage]) {
            imageViewArr(2).image = [self getImageForIndex:index];
        }
    });
}

- (UIImage *)getImageForIndex:(NSInteger)index {
    if (self.privateImages.count == 0) {
        if (self.placeholder) {
            return self.placeholder;
        } else {
            return nil;
        }
    }
    NSObject *object = self.privateImages[index];
    if ([object isKindOfClass:[UIImage class]]) {
        return (UIImage *)object;
    }
    if ([object isKindOfClass:[NSString class]]) {
        UIImage *image = self.cacheDict[(NSString *)object];
        if (image) {
            return image;
        } else {
            [self downloadImage:(NSString *)object forIndex:index];
            return self.placeholder;
        }
    }
    return nil;
}

/** 滚动后刷新所有图片 */
- (void)reloadImageViewsImage {
    imageViewArr(1).image = [self getImageForIndex:self.pageControl.currentPage];
    if (self.privateImages.count > 1) {
        imageViewArr(0).image = [self getImageForIndex:[self prePage]];
        imageViewArr(2).image = [self getImageForIndex:[self nextPage]];
    } else {
        imageViewArr(0).image = nil;
        imageViewArr(2).image = nil;
    }
}

/** 翻页后对imageViews处理 */
- (void)updateImageViewsDidEndScrolling {
    // 计算滑动后当前的页数
    BOOL turnRight = (self.bannerView.contentOffset.x < self.frame.size.width) ? NO : YES;
    // 更新pageControl
    self.pageControl.currentPage = turnRight ? [self nextPage] : [self prePage];
    // offset移到中间
    self.bannerView.contentOffset = CGPointMake(self.bannerView.frame.size.width, 0);
    [self reloadImageViewsImage];
    self.bannerView.userInteractionEnabled = YES;
    // 通知代理图片更换了
    ifDelegateRespone(bannerViewPictureDidChanged:) {
        [_delegate bannerViewPictureDidChanged:self];
    }
}

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragByUser = YES;
    if (self.privateImages.count > 1) {
        [self stopTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isDragByUser) {
        ifDelegateRespone(bannerViewPictureDidDragByUser:) {
            [_delegate bannerViewPictureDidDragByUser:self];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.isDragByUser = NO;
    if (self.privateImages.count > 1) {
        [self startTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 拖动完成后自动回到中间的情况无须刷新
    if (scrollView.contentOffset.x == self.bannerView.frame.size.width) return;
    // 刷新
    [self updateImageViewsDidEndScrolling];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.bannerView];
}

- (void)scrollByTimer {
    if (self.images.count > 1) {
        self.bannerView.userInteractionEnabled = NO;
        CGPoint offset = CGPointMake(self.bannerView.frame.size.width * 2, 0);
        [self.bannerView setContentOffset:offset animated:YES];
    } else {
        [self stopTimer];
    }
}

- (void)dealloc {
    [self stopTimer];
}

#pragma mark 下载操作
/** 网络下载图片 */
- (void)downloadImage:(NSString *)url forIndex:(NSInteger)index {
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.config];
    NSDate *taskDate = [self.lastUpdate copy];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            if (![taskDate isEqualToDate:self.lastUpdate]) return;
            if (self.privateImages.count > index) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    self.cacheDict[url] = image;
                    [self reloadAfterDownloadForIndex:index];
                } else {
                    NSLog(@"JHBannerView从地址%@获取的数据无法转换成UIImage对象", url);
                }
            }
        }
    }];
    [task resume];
}

@end

