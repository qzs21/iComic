//
//  ICComicListItem.h
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICComicImage.h"
#import "ICBaseModel.h"

@protocol ICComicListItem <NSObject> @end

/// 漫画列表元素
@interface ICComicListItem : ICBaseModel


@property (nonatomic, strong) NSString * workid;    ///< 漫画ID
@property (nonatomic, strong) NSString * title;     ///< 漫画标题
@property (nonatomic, strong) ICComicImage * image; ///< 漫画缩略图URL
@property (nonatomic, assign) float score;          ///< 评分
@property (nonatomic, assign) NSInteger volumecount;///< 章节总数
@property (nonatomic, strong) NSString * painter;   ///< 漫画绘图作者
@property (nonatomic, strong) NSString * writer;    ///< 剧情文案作者
@property (nonatomic, assign) BOOL free;            ///< 免费

+ (void)addHistory:(ICComicListItem *)item;   ///< 添加历史
+ (void)addFavorite:(ICComicListItem *)item;  ///< 添加收藏

+ (NSMutableArray *)getHistorys; ///< 获取所有历史
+ (NSMutableArray *)getFavorite; ///< 获取所有收藏

+ (void)removeHistory:(ICComicListItem *)item;    ///< 删除历史
+ (void)removeFavorite:(ICComicListItem *)item;   ///< 删除收藏

+ (void)removeAllHistorys;    ///< 删除所有历史
+ (void)removeAllFavorites;   ///< 删除所有收藏

+ (BOOL)hasHistory:(ICComicListItem *)item; ///< 是否有此历史纪录
+ (BOOL)hasFavorite:(ICComicListItem *)item; ///< 是否有该收藏纪录

@end
