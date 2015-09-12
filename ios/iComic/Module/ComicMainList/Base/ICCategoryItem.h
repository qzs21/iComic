//
//  ICCategoryItem.h
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//


@import JSONModel;
@import UIKit;

#import "ICSubCategoryItem.h"

/// 主分类对象
@interface ICCategoryItem : JSONModel

/// 分类标题
@property (nonatomic, strong) NSString * title;

/// 子分类集合
@property (nonatomic, strong) NSArray <ICSubCategoryItem> * subCategoryItems;

/// 列表位置偏移
@property (nonatomic, assign) CGPoint contentOffset;

/// 子分类当前选择
@property (nonatomic, assign) NSUInteger subCategoryItemsIndex;

/// 当前选中的子分类
@property (nonatomic, readonly) ICSubCategoryItem * currentSelectedSubCategoryItem;

@end