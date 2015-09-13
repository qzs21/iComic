//
//  ComicMainListVC.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ComicMainListVC.h"
#import "ICCategoryItem.h"
#import "ICNetworkDataCenter.h"
#import "ComicMainListCell.h"
#import "ComicDetailVC.h"

@import MJRefresh;

@interface ComicMainListVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    __strong NSArray * _categoryItems;
    __strong NSArray * _categoryTitleItems;
}

@property (nonatomic, assign) IBOutlet UITableView * leftTableView;
@property (nonatomic, assign) IBOutlet UITableView * rightTableView;

@property (nonatomic, strong, readonly) NSArray * categoryItems; // 主分类数据
@property (nonatomic, strong, readonly) NSArray * categoryTitleItems; // 主分类标题列表
@property (nonatomic, readonly) ICCategoryItem * currentCategoryItem; // 当前选择的主分类
@property (nonatomic, assign) NSUInteger categoryItemsIndex; // 但前选择的主分类

@property (nonatomic, strong) NSIndexPath * currentSelectIndexPath; // 当前点击进入的Cell索引，用于返回时取消Cell选择

@end

@implementation ComicMainListVC

// 获取所有主分类
- (NSArray *)categoryItems
{
    if (_categoryItems == nil) {

        /// 初始化分类数据
        NSArray * initConfig =
        @[
          @{@"title": @"我的",
            @"subCategoryItems": @[
                    @{@"title": @"最近"},
                    @{@"title": @"收藏"}]
            },
          
          @{@"title": @"最新",
            @"subCategoryItems": @[
                    @{@"title": @"最新", @"URL": ICAPINewest},
                    @{@"title": @"周一", @"URL": ICAPIWeek1},
                    @{@"title": @"周二", @"URL": ICAPIWeek2},
                    @{@"title": @"周三", @"URL": ICAPIWeek3},
                    @{@"title": @"周四", @"URL": ICAPIWeek4},
                    @{@"title": @"周五", @"URL": ICAPIWeek5},
                    @{@"title": @"周六", @"URL": ICAPIWeek6},
                    @{@"title": @"周日", @"URL": ICAPIWeek7}]
            },
          
          @{@"title": @"题材"},
          
          @{@"title": @"连载",
            @"subCategoryItems": @[
                    @{@"title": @"推荐", @"URL": ICAPISerialRecommended},
                    @{@"title": @"排行", @"URL": ICAPISerialRanking}]
            },
          
          @{@"title": @"完结",
            @"subCategoryItems": @[
                    @{@"title": @"推荐", @"URL": ICAPIFinishRecommended},
                    @{@"title": @"排行", @"URL": ICAPIFinishRanking},
                    @{@"title": @"评分", @"URL": ICAPIFinishScore},
                    @{@"title": @"最新", @"URL": ICAPIFinishNewest}]
            },
          
          ];
        
        _categoryItems = [ICCategoryItem arrayOfModelsFromDictionaries:initConfig];
    }
    return _categoryItems;
}

// 获取当前主分类
- (ICCategoryItem *)currentCategoryItem
{
    return self.categoryItems[self.categoryItemsIndex];
}

- (NSArray *)categoryTitleItems
{
    if (_categoryTitleItems == nil)
    {
        NSMutableArray * items = [NSMutableArray array];
        for (ICCategoryItem * i in self.categoryItems)
        {
            if (i.title)
            {
                [items addObject:i.title];
            }
        }
        if (items.count)
        {
            _categoryTitleItems = [NSArray arrayWithArray:items];
        }
    }
    return _categoryTitleItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"iComic";
}


- (void)reloadAllTableView
{
    // 刷新内容
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    // 恢复TableView偏移量
    self.leftTableView.contentOffset = self.currentCategoryItem.contentOffset;
    self.rightTableView.contentOffset = self.currentCategoryItem.currentSelectedSubCategoryItem.contentOffset;
    
    [self updateFooter];
}

- (void)updateFooter
{
    ICSubCategoryItem * subItem = self.currentCategoryItem.currentSelectedSubCategoryItem;
    [self.rightTableView.footer endRefreshing];
    if (subItem.page > subItem.totalpage) {
        [self.rightTableView.footer noticeNoMoreData];
    }
}

// 条件合适，获取数据
- (void)loadComicListWithSubItem:(ICSubCategoryItem *)subItem;
{
    [self loadComicListWithSubItem:subItem block:nil];
}
- (void)loadComicListWithSubItem:(ICSubCategoryItem *)subItem block:(ICNetworkDataCenterBlock)block
{
    if (subItem.URL)
    {
        @weakify(self);
        [ICNetworkDataCenter GET:subItem.URL page:subItem.page block:^(id object, BOOL isCache) {
            @strongify(self);
            
            if (object)
            {
                NSArray * data = [ICComicListItem arrayOfModelsFromDictionaries:object[@"work"]];
                if (subItem.page == 1) {
                    subItem.totalpage = [object[@"totalpage"] integerValue];
                    [subItem.comicItems removeAllObjects];
                }
                [subItem.comicItems addObjectsFromArray:data];
                if (!isCache) {
                    subItem.page++;
                }
                
                [self updateFooter];
                [self.rightTableView reloadData];
            }
            if (block) { block(object, isCache); }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /// 取消选择
    [self.rightTableView deselectRowAtIndexPath:self.currentSelectIndexPath animated:YES];
    
    /// 导航栏设置
    UISegmentedControl * segmented = [[UISegmentedControl alloc] initWithItems:self.categoryTitleItems];
    segmented.selectedSegmentIndex = self.categoryItemsIndex;
    segmented.tintColor = ICTintColor;
    @weakify(self);
    [[segmented rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl * x) {
        @strongify(self);
        self.categoryItemsIndex = x.selectedSegmentIndex;
        
        @weakify(self);
        if (self.categoryItemsIndex == 0)
        {
            self.rightTableView.header = nil;
            self.rightTableView.footer = nil;
        }
        else
        {
            // 下拉刷新
            self.rightTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                
                ICSubCategoryItem * subItem = self.currentCategoryItem.currentSelectedSubCategoryItem;
                subItem.page = 1;
                subItem.contentOffset = CGPointZero;
                [subItem.comicItems removeAllObjects];
                
                [self reloadAllTableView];
                
                @weakify(self);
                [self loadComicListWithSubItem:subItem block:^(id object, BOOL isCache) {
                    @strongify(self);
                    [self.rightTableView.header endRefreshing];
                }];
            }];
            self.rightTableView.header.automaticallyChangeAlpha = YES;
            
            // 上拉加载更多
            self.rightTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                @strongify(self);
                
                ICSubCategoryItem * subItem = self.currentCategoryItem.currentSelectedSubCategoryItem;
                [self loadComicListWithSubItem:subItem];
            }];
        }
        
        // 刷新界面
        [self reloadAllTableView];
        
        // 如果不存在分类，就加载分类
        if (self.categoryItemsIndex == 2 && self.currentCategoryItem.subCategoryItems.count == 0)
        {
            ICCategoryItem * item = self.currentCategoryItem;
            @weakify(self);
            [ICNetworkDataCenter GET:ICAPIGenres params:nil block:^(id object, BOOL isCache) {
                @strongify(self);
                NSMutableArray * array = [NSMutableArray array];
                ICSubCategoryItem * subItem = nil;
                for (NSDictionary * d in object[@"genre"])
                {
                    subItem = [[ICSubCategoryItem alloc] init];
                    subItem.title = d[@"name"];
                    subItem.URL = [NSString stringWithFormat:@"%@?genreid=%@", ICAPITheme, d[@"id"]];
                    [array addObject:subItem];
                    subItem = nil;
                }
                if (array.count)
                {
                    // 成功获取分类，加载列表
                    item.subCategoryItems = (id)[NSArray arrayWithArray:array];
                    [self reloadAllTableView];
                    [self loadComicListWithSubItem:self.currentCategoryItem.currentSelectedSubCategoryItem];
                }
            }];
        }
        else
        {
            if (self.currentCategoryItem.currentSelectedSubCategoryItem.comicItems.count == 0)
            {
                [self loadComicListWithSubItem:self.currentCategoryItem.currentSelectedSubCategoryItem];
            }
        }
    }];
    self.navigationItem.titleView = segmented;
    
    
    
    if (self.categoryItemsIndex == 0)
    {
        switch (self.currentCategoryItem.subCategoryItemsIndex)
        {
            case 0:
            {
                // 读取最近并刷新界面
                self.currentCategoryItem.currentSelectedSubCategoryItem.comicItems = (id)[ICComicListItem getHistorys];
                [self.rightTableView reloadData];
                break;
            }
            case 1:
            {
                // 读取收藏并刷新界面
                self.currentCategoryItem.currentSelectedSubCategoryItem.comicItems = (id)[ICComicListItem getFavorite];
                [self.rightTableView reloadData];
                break;
            }
            default: break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ICCategoryItem * item = self.categoryItems[self.categoryItemsIndex];
    if (self.leftTableView == tableView)
    {
        // 子分类数量
        return item.subCategoryItems.count;
    }
    else
    {
        // 当前选择的自分类下面的漫画数量
        return item.currentSelectedSubCategoryItem.comicItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICCategoryItem * item = self.currentCategoryItem;
    if (self.leftTableView == tableView)
    {
        ICSubCategoryItem * subItem = item.subCategoryItems[indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = subItem.title;
        cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
        cell.textLabel.textColor = indexPath.row == item.subCategoryItemsIndex ?
        ICTintColor : [UIColor lightGrayColor];
        return cell;
    }
    else
    {
        ICComicListItem * comic = item.currentSelectedSubCategoryItem.comicItems[indexPath.row];
        ComicMainListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.titleLab.text = comic.title;
        cell.scoreView.value = comic.score;
        cell.scoreView.tintColor = ICTintColor;
        [cell.thumbnailImg sd_setImageWithURL:[NSURL URLWithString:comic.image.url] placeholderImage:nil];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICCategoryItem * item = self.currentCategoryItem;
    if (self.leftTableView == tableView)
    {
        // 左边TableView点击
        
        item.subCategoryItemsIndex = indexPath.row;
        ICSubCategoryItem * subItem = item.currentSelectedSubCategoryItem;
        
        // 刷新界面
        [self reloadAllTableView];
        
        // 列表下无数据，自动刷新当前界面，并发起请求
        if (subItem.comicItems.count == 0)
        {
            [self loadComicListWithSubItem:subItem];
        }
    }
    else
    {
        self.currentSelectIndexPath = indexPath;
        
        ICComicListItem * comic = item.currentSelectedSubCategoryItem.comicItems[indexPath.row];
        ComicDetailVC * vc = (id)[UIViewController getViewControllerFromStoryboard:@"Detail" key:@"DetailViewController"];
        vc.detail = [[ICComicDetail alloc] initWithDictionary:comic.toDictionary error:nil];
        [self.navigationController push:vc animated:UINavigationControllerAnimatedPush];
        
        [ICComicListItem addHistory:comic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.categoryItemsIndex == 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ICSubCategoryItem * item = self.currentCategoryItem.currentSelectedSubCategoryItem;
    ICComicListItem * listItem = item.comicItems[indexPath.row];
    if (self.currentCategoryItem.subCategoryItemsIndex == 0)
    {
        // 删除历史
        [ICComicListItem removeHistory:listItem];
    }
    else
    {
        // 删除收藏
        [ICComicListItem removeFavorite:listItem];
    }
    [item.comicItems removeObject:listItem];
    [self.rightTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 保存TableView位置偏移量
    if (self.leftTableView == scrollView)
    {
        self.currentCategoryItem.contentOffset = scrollView.contentOffset;
    }
    else
    {
        self.currentCategoryItem.currentSelectedSubCategoryItem.contentOffset = scrollView.contentOffset;
    }
}

@end
