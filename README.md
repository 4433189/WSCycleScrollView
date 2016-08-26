# WSCycleScrollView
无限循环自动图片轮播器


# PhotoShoot
![image](https://github.com/Zws-China/WSCycleScrollView/blob/master/WSCycleScrollView/WSCycleScrollView/scroll.gif)


# How To Use
宏定义
#####define kScreenWidth [UIScreen mainScreen].bounds.size.width
#####define kScreenHeight [UIScreen mainScreen].bounds.size.height  


WSPageView *pageView = [[WSPageView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight/4)];\
pageView.delegate = self;\
pageView.dataSource = self;\
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



#----代理方法----
#### #pragma mark NewPagedFlowView Delegate
-(CGSize)sizeForPageInFlowView:(WSPageView *)flowView {
return CGSizeMake(kScreenWidth - 84, kScreenHeight/4);
}

-(void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {

NSLog(@"点击了第%ld张图",(long)subIndex + 1);

}

#### #pragma mark NewPagedFlowView Datasource
-(NSInteger)numberOfPagesInFlowView:(WSPageView *)flowView {
return self.imageArray.count;
}

-(UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
if (!bannerView) {
bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 84, kScreenHeight/4)];
bannerView.layer.cornerRadius = 4;
bannerView.layer.masksToBounds = YES;
}

bannerView.mainImageView.image = self.imageArray[index];

return bannerView;
}

-(void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSPageView *)flowView {

NSLog(@"滚动到了第%ld页",pageNumber);
}
