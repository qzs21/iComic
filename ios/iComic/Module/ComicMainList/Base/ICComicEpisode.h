//
//  ICComicEpisode.h
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICBaseModel.h"
#import "ICComicImage.h"

@protocol ICComicEpisode <NSObject> @end

/// 漫画剧集
@interface ICComicEpisode : ICBaseModel

@property (nonatomic, strong) NSString * image;         ///< 缩略图
@property (nonatomic, strong) NSDate * date;            ///< 更新时间
@property (nonatomic, assign) NSInteger score;          ///< 评分
@property (nonatomic, strong) NSString * title;         ///< 本集标题
@property (nonatomic, strong) NSString * volumeid;      ///< 本集ID
@property (nonatomic, strong) NSString * workid;        ///< 漫画ID


+ (void)addHistory:(ICComicEpisode *)episode;   ///< 添加历史
+ (void)addFavorite:(ICComicEpisode *)episode;  ///< 添加收藏

+ (NSArray *)getHistorys; ///< 获取所有历史
+ (NSArray *)getFavorite; ///< 获取所有收藏

+ (void)removeHistory:(ICComicEpisode *)episode;    ///< 删除历史
+ (void)removeFavorite:(ICComicEpisode *)episode;   ///< 删除收藏

+ (void)removeAllHistorys;    ///< 删除所有历史
+ (void)removeAllFavorites;   ///< 删除所有收藏

@end
