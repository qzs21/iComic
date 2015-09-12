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
}

@end
