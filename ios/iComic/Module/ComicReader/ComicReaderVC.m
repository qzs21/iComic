//
//  ComicReaderVC.m
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ComicReaderVC.h"
#import "ComicReaderTableViewCell.h"

@import Masonry;

@interface ComicReaderVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * comicPageItems; // 漫画内容页

@property (nonatomic, assign) BOOL showTopBar; // 显示顶部栏

@end

@implementation ComicReaderVC

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        // 设置初始化
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)setShowTopBar:(BOOL)showTopBar
{
    _showTopBar = showTopBar;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:!showTopBar animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.showTopBar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.showTopBar = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:ComicReaderTableViewCell.class forCellReuseIdentifier:@"cell"];

    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    // 布局
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    /// 获取剧集信息
    NSDictionary * param = @{@"workid": SAVE_STRING(self.episode.workid),
                             @"volumeid": SAVE_STRING(self.episode.volumeid)};
    [ICNetworkDataCenter GET:ICAPIEpisode params:param block:^(id object, BOOL isCache) {
        
        self.comicPageItems = [ICComicImage arrayOfModelsFromDictionaries:object[@"page"]];
        
        [self.tableView reloadData];
    }];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSMutableArray * items = [NSMutableArray array];
//    for (int i = 0; i < self.comicPageItems.count; i++) {
//        [items addObject:[NSString stringWithFormat:@"%d", i+1]];
//    }
//    return [NSArray arrayWithArray:items];
//}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @[@"1", @"2", @"3"][section];
//}
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
//{
//    return index;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.comicPageItems.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICComicImage * comicImage = self.comicPageItems[indexPath.section];
    ComicReaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.contentImg sd_setImageWithURL:[NSURL URLWithString:comicImage.url]];
    
    NSString * text =[NSString stringWithFormat:@"%d", (int)indexPath.section+1];
    cell.titleLab.text = (indexPath.section + 1) % 10 == 0 ? text : nil;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ICComicImage * comicImage = self.comicPageItems[indexPath.section];
    return (comicImage.height / comicImage.width) * tableView.width;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.showTopBar = !self.showTopBar;
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
//}

- (BOOL)prefersStatusBarHidden
{
    return !_showTopBar;
}


@end
