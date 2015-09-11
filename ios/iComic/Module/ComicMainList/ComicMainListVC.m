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

@interface ComicMainListVC () <UITableViewDataSource, UITableViewDelegate>
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
}

// 刷新当前界面，并发起请求
- (void)loadComicListWithSubItem:(ICSubCategoryItem *)subItem;
{
    // 刷新
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];

    // 条件合适，获取数据
    if (subItem.URL && subItem.comicItems.count == 0)
    {
        @weakify(self);
        [ICNetworkDataCenter GET:subItem.URL page:subItem.page block:^(id object) {
            @strongify(self);
            NSArray * data = [ICComicListItem arrayOfModelsFromDictionaries:object[@"work"]];
            [subItem addComicListArray:data];
            [self.rightTableView reloadData];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UISegmentedControl * segmented = [[UISegmentedControl alloc] initWithItems:self.categoryTitleItems];
    segmented.selectedSegmentIndex = self.categoryItemsIndex;
    @weakify(self);
    [[segmented rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl * x) {
        @strongify(self);
        self.categoryItemsIndex = x.selectedSegmentIndex;
        [self loadComicListWithSubItem:self.currentCategoryItem.currentSelectedSubCategoryItem];
    }];
    self.navigationItem.titleView = segmented;
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
        cell.textLabel.textColor = indexPath.row == item.subCategoryItemsIndex ?
        [UIColor redColor] : [UIColor lightGrayColor];
        return cell;
    }
    else
    {
        ICComicListItem * comic = item.currentSelectedSubCategoryItem.comicItems[indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = comic.title;
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
        
        // 刷新当前界面，并发起请求
        [self loadComicListWithSubItem:subItem];
    }
    else
    {
        // TODO 右边TableView点击
        
    }
}

@end
