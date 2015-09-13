//
//  ICBaseViewController.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICBaseViewController.h"

@import JSONModel;

@interface ICBaseViewController ()

@property (nonatomic, strong) UIView * leftView; ///< 修复右边返回手势冲突

@end

@implementation ICBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ICBackgroundColor;
    
    [self do_once_with_key:do_once_in_this_function_key block:^{
        // 全局转换键值对应关系
        JSONKeyMapper * maper =[[JSONKeyMapper alloc] initWithDictionary:
        @{
          @"cover": @"image"
        }];
        [JSONModel setGlobalKeyMapper:maper];
    }];
    
    _leftView = [[UIView alloc] init];
    [self.view addSubview:_leftView];
    _leftView.backgroundColor = [UIColor clearColor];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@12);
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.view bringSubviewToFront:_leftView];
}

@end
