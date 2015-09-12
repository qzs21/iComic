//
//  ComicReaderVC.m
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ComicReaderVC.h"
#import "ICComicDetail.h"

@import Masonry;

@interface ComicReaderVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) ICComicDetail * detail; ///< 漫画详情

@end

@implementation ComicReaderVC

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        // 设置初始化
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    // 布局
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    [ICNetworkDataCenter GET:ICAPIComicDetail params:@{@"workid": SAVE_STRING(self.workid)} block:^(id object, BOOL isCache) {
        @strongify(self);
        self.detail = [[ICComicDetail alloc] initWithDictionary:object error:nil];
        [self.tableView reloadData];
    }];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"1", @"2", @"3"];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"1", @"2", @"3"][section];
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
