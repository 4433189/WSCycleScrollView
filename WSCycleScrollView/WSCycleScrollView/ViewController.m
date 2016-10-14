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
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<WSPageViewDelegate,WSPageViewDataSource,UITableViewDelegate,UITableViewDataSource>


@end

@implementation ViewController{
    NSMutableArray *array;
    NSMutableArray *ImgURLArray;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [@"http://image.baidu.com/channel/listjson?pn=0&rn=6&tag1=美女&tag2=全部&ie=utf8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        array = responseObject[@"data"];
        
        ImgURLArray = [NSMutableArray array];
        for (NSInteger i = 0; i < array.count-1; i++) {
            NSDictionary *dic = array[i];
            NSString *url = dic[@"image_url"];
            [ImgURLArray addObject:url];//装图片地址
        }
      
        [self creatTabV];
      
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    


}

- (void)creatTabV {
    
    UITableView *tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20) style:UITableViewStyleGrouped];
    tableV.dataSource = self;
    tableV.delegate = self;
    [self.view addSubview:tableV];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld位老司机翻车啦",indexPath.row];
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScreenHeight/4+10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //创建页面显示
    return [self creatUI];
}



- (UIView *)creatUI {
    
    WSPageView *pageView = [[WSPageView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight/4)];
    pageView.delegate = self;
    pageView.dataSource = self;
    pageView.minimumPageAlpha = 0.4;   //非当前页的透明比例
    pageView.minimumPageScale = 0.85;  //非当前页的缩放比例
    pageView.orginPageCount = ImgURLArray.count; //原始页数
    pageView.autoTime = 3;    //自动切换视图的时间,默认是5.0
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageView.frame.size.height - 8 - 10, kScreenWidth, 8)];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageView.pageControl = pageControl;
    [pageView addSubview:pageControl];
    [pageView startTimer];
    [self.view addSubview:pageView];
    
    return pageView;
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
    return ImgURLArray.count;
}

- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
    WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 84, kScreenHeight/4)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
//    bannerView.mainImageView.image = self.imageArray[index];
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:ImgURLArray[index]]];
    
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
