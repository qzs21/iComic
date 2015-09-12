//
//  ICComicListItem.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICComicListItem.h"

@import TMCache;

#define ICComicEpisodeHistoryKey    @"ICComicEpisodeHistoryKey"
#define ICComicEpisodeFavoriteKey   @"ICComicEpisodeFavoriteKey"

@implementation ICComicListItem

+ (NSMutableArray *)getCacheArrayWithKey:(NSString *)key
{
    
    NSMutableArray * array = [[TMCache sharedCache] objectForKey:key];
    if (array == nil)
    {
        array = [NSMutableArray array];
        [[TMCache sharedCache] setObject:array forKey:key block:nil];
    }
    return array;
}

+ (void)saveCacheArray:(NSMutableArray *)array withKey:(NSString *)key;
{
    [[TMCache sharedCache] setObject:array forKey:key block:nil];
}

+ (void)addCacheItem:(ICComicListItem *)item withKey:(NSString *)key;
{
    NSMutableArray * array = [self getCacheArrayWithKey:key];
    
    ICComicListItem * oldItem = nil;
    for (ICComicListItem * i in array)
    {
        if ([i.workid isEqualToString:item.workid])
        {
            oldItem = i;
            break;
        }
    }
    if (oldItem)
    {
        [array removeObject:oldItem];
    }
    [array insertObject:item atIndex:0];
    [self saveCacheArray:array withKey:key];
}

+ (void)addHistory:(ICComicListItem *)item;   ///< 添加历史
{
    [self addCacheItem:item withKey:ICComicEpisodeHistoryKey];
}

+ (void)addFavorite:(ICComicListItem *)item;  ///< 添加收藏
{
    [self addCacheItem:item withKey:ICComicEpisodeFavoriteKey];
}

+ (NSMutableArray *)getHistorys; ///< 获取所有历史
{
    return [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
}

+ (NSMutableArray *)getFavorite; ///< 获取所有收藏
{
    return [self getCacheArrayWithKey:ICComicEpisodeFavoriteKey];
}

+ (void)removeHistory:(ICComicListItem *)item;    ///< 删除历史
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
    [array removeObject:item];
    [self saveCacheArray:array withKey:ICComicEpisodeHistoryKey];
}

+ (void)removeFavorite:(ICComicListItem *)item;   ///< 删除收藏
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
    [array removeObject:item];
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
