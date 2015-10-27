#JHBannerView

JHBannerView是一个使用方便且功能齐全的图片轮播控件,版本最低要求为iOS7.

![image](https://github.com/TonyStark106/JHBannerView/blob/master/demo.gif)

## 特性
1. 传入的数据源类型可以是UIImage和NSString(图片url)混合数组
2. 已建立缓存机制防止多次传入相同的url导致图片的重复下载
3. 遵守JHBannerViewDelegate就可以监听JHBannerView的状态切换

## 使用方法
1. 直接将JHBannerView.h和JHBannerView.m两个文件拖入项目中
2. cocoapods: `pod 'JHBannerView'`

## 示例代码
```objc
NSArray *images = @[image1 ,image2, image3, @"http://imgsrc.baidu.com/forum/pic/item/0ff41bd5ad6eddc43f96e84539dbb6fd5266331e.jpg"];
JHBannerView *bannerView = [JHBannerView bannerViewWithFrame:CGRectZero andImages:images];
[self.view addSubview:bannerView];
bannerView.alignment = JHBannerViewPageControlAlignmentTypeRight;
bannerView.delegate = self;
```