//
//  ICComicEpisode.m
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICComicEpisode.h"

@import TMCache;

#define ICComicEpisodeHistoryKey    @"ICComicEpisodeHistoryKey"
#define ICComicEpisodeFavoriteKey   @"ICComicEpisodeFavoriteKey"

@implementation ICComicEpisode

+ (NSMutableArray *)getCacheArrayWithKey:(NSString *)key
{
    
    NSMutableArray * array = [[TMCache sharedCache] objectForKey:key];
    if (array == nil)
    {
        array = [NSMutableArray array];
    }
    return array;
}

+ (void)saveCacheArray:(NSMutableArray *)array withKey:(NSString *)key;
{
    [[TMCache sharedCache] setObject:array forKey:key block:nil];
}

+ (void)addHistory:(ICComicEpisode *)episode;   ///< 添加历史
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
    [array addObject:episode];
    [self saveCacheArray:array withKey:ICComicEpisodeHistoryKey];
}
+ (void)addFavorite:(ICComicEpisode *)episode;  ///< 添加收藏
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeFavoriteKey];
    [array addObject:episode];
    [self saveCacheArray:array withKey:ICComicEpisodeFavoriteKey];
}

+ (NSArray *)getHistorys; ///< 获取所有历史
{
    return [NSArray arrayWithArray:[self getCacheArrayWithKey:ICComicEpisodeHistoryKey]];
}

+ (NSArray *)getFavorite; ///< 获取所有收藏
{
    return [NSArray arrayWithArray:[self getCacheArrayWithKey:ICComicEpisodeFavoriteKey]];
}

+ (void)removeHistory:(ICComicEpisode *)episode;    ///< 删除历史
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
    [array removeObject:episode];
    [self saveCacheArray:array withKey:ICComicEpisodeHistoryKey];
}

+ (void)removeFavorite:(ICComicEpisode *)episode;   ///< 删除收藏
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
    [array removeObject:episode];
    [self saveCacheArray:array withKey:ICComicEpisodeFavoriteKey];
}

+ (void)removeAllHistorys;    ///< 删除所有历史
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
    [array removeAllObjects];
    [self saveCacheArray:array withKey:ICComicEpisodeHistoryKey];
}

+ (void)removeAllFavorites;   ///< 删除所有收藏
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
    [array removeAllObjects];
    [self saveCacheArray:array withKey:ICComicEpisodeFavoriteKey];

}

@end
