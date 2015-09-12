//
//  ICSubCategoryItem.h
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICComicListItem.h"
#import "ICBaseModel.h"

@protocol ICSubCategoryItem <NSObject> @end

/// 子分类对象
@interface ICSubCategoryItem : ICBaseModel

@property (nonatomic, strong) NSString * title; ///< 子分类标题
@property (nonatomic, strong) NSString * URL; ///< 获取分类下的数据
@property (nonatomic, assign) NSInteger page; ///< 当前加载到的页码
@property (nonatomic, assign) NSInteger totalpage; ///< 最大页码
@property (nonatomic, strong) NSMutableArray <ICComicListItem> * comicItems; ///< 分类下漫画列表
@property (nonatomic, assign) CGPoint contentOffset; ///< 列表偏移

@end
