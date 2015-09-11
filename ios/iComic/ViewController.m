//
//  ViewController.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBOutlet UITableView * leftTableView;
@property (nonatomic, assign) IBOutlet UITableView * rightTableView;

@property (nonatomic, strong) NSMutableDictionary <NSString*, NSMutableArray *> * leftTableViewItems;
@property (nonatomic, strong) NSMutableDictionary <NSString*, NSMutableArray *> * rightTableViewItems;

@end

@implementation ViewController

- (NSMutableDictionary <NSString*, NSMutableArray *> *)leftTableViewItems
{
    if (_leftTableViewItems == nil) {
        _leftTableViewItems = [NSMutableDictionary dictionary];
    }
    return _leftTableViewItems;
}

- (NSMutableDictionary <NSString*, NSMutableArray *> *)rightTableViewItems
{
    if (_rightTableViewItems == nil) {
        _rightTableViewItems = [NSMutableDictionary dictionary];
    }
    return _rightTableViewItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UISegmentedControl * segmented = [[UISegmentedControl alloc] initWithItems:@[@"我的", @"最新", @"分类", @"连载", @"完结"]];
    self.navigationItem.titleView = segmented;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.leftTableView == tableView)
    {
        return self.leftTableViewItems.count;
    }
    return self.rightTableViewItems.count;
}

@end
