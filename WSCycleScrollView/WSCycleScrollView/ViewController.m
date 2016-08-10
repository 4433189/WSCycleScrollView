//
//  ViewController.m
//  WSCycleScrollView
//
//  Created by iMac on 16/8/10.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import "ViewController.h"
#import "WSPageView.h"
#import "WSIndexBanner.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<WSPageViewDelegate,WSPageViewDataSource>
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation ViewController

//懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    for (NSInteger index = 0; index < 5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",index]];
        [self.imageArray addObject:image];
    }

    //创建页面显示
    [self creatUI];
}

- (void)creatUI {
    
    WSPageView *pageView = [[WSPageView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight/4)];
    pageView.delegate = self;
    pageView.dataSource = self;
    pageView.minimumPageAlpha = 0.4;   //非当前页的透明比例
    pageView.minimumPageScale = 0.85;  //非当前页的缩放比例
    pageView.orginPageCount = self.imageArray.count; //原始页数
    pageView.autoTime = 3;    //自动切换视图的时间,默认是5.0
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageView.frame.size.height - 8 - 10, kScreenWidth, 8)];
    pageView.pageControl = pageControl;
    [pageView addSubview:pageControl];
    [pageView startTimer];
    [self.view addSubview:pageView];
    
}



#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(WSPageView *)flowView {
    return CGSizeMake(kScreenWidth - 84, kScreenHeight/4);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);

}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(WSPageView *)flowView {
    return self.imageArray.count;
}

- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
    WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 84, kScreenHeight/4)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSPageView *)flowView {
    
    NSLog(@"滚动到了第%ld页",pageNumber);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
