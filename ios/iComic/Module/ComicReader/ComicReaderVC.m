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
@import TMCache;

@interface ComicReaderVC () <UITableViewDataSource, UITableViewDelegate>
{
    __strong NSString * _cacheKey;
}

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * comicPageItems; ///< 漫画内容页

@property (nonatomic, assign) BOOL showTopBar; ///< 显示顶部栏

@property (nonatomic, strong, readonly) NSString * cacheKey; ///< 缓存Key

@end

@implementation ComicReaderVC

- (void)dealloc
{
    [[TMCache sharedCache] setObject:[NSValue valueWithCGPoint:self.tableView.contentOffset] forKey:self.cacheKey];
}

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

- (NSString *)cacheKey
{
    // 缓存上次观看的contentOffset
    if (_cacheKey == nil)
    {
        _cacheKey = [NSString stringWithFormat:@"ComicReaderVC.workid.%@.volumeid.%@", self.episode.workid, self.episode.volumeid];
    }
    return _cacheKey;
}

- (void)setShowTopBar:(BOOL)showTopBar
{
    _showTopBar = showTopBar;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:!showTopBar animated:YES];
    
    
    CGSize size = self.tableView.contentSize;
    CGPoint contentOffset = self.tableView.contentOffset;
    self.tableView.contentOffset = CGPointMake(MIN(size.width, contentOffset.x), MIN(size.height, contentOffset.y));

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
    
    self.title = self.episode.title;
    
    // 点击时收起或隐藏顶部栏
    @weakify(self);
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        self.showTopBar = !self.showTopBar;
    }];
    tapGesture.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tapGesture];
    
    // 布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    /// 获取剧集信息
    NSDictionary * param = @{@"workid": SAVE_STRING(self.episode.workid),
                             @"volumeid": SAVE_STRING(self.episode.volumeid)};
    [ICNetworkDataCenter GET:ICAPIEpisode params:param block:^(id object, BOOL isCache) {
        @strongify(self);
        if (object) {
            self.comicPageItems = [ICComicImage arrayOfModelsFromDictionaries:object[@"page"]];
            [self.tableView reloadData];
            @weakify(self);
            [[TMCache sharedCache] objectForKey:self.cacheKey block:^(TMCache *cache, NSString *key, id object) {
                @strongify(self);
                NSValue * value = object;
                if (value)
                {
                    CGPoint contentOffset;
                    [value getValue:&contentOffset];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.tableView.contentOffset = contentOffset;
                    });
                }
            }];
        }
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
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ICComicImage * comicImage = self.comicPageItems[indexPath.section];
    return (comicImage.height / comicImage.width) * tableView.width;
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

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

@end
