//
//  ICSubCategoryItem.h
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <JSONModel.h>

#import "ICComicListItem.h"

@protocol ICSubCategoryItem <NSObject>
@end

// 子分类对象
@interface ICSubCategoryItem : JSONModel

// 子分类标题
@property (nonatomic, strong) NSString * title;

// 获取分类下的数据
@property (nonatomic, strong) NSString * URL;

// 当前加载到的页码
@property (nonatomic, assign) NSUInteger page;

// 分类下漫画列表
@property (nonatomic, readonly) NSArray <ICComicListItem> * comicItems;

// 列表偏移
@property (nonatomic, assign) float contentOffset;

- (void)addComicListArray:(NSArray *)array;

@end
