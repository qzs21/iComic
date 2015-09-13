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
    
    // 已经存在纪录删除，后面重新添加，移到前面
    if ([self hasCacheItem:item withKey:key])
    {
        for (ICComicListItem * i in array)
        {
            if ([i.workid isEqualToString:item.workid])
            {
                [array removeObject:i];
                break;
            }
        }
    }
    
    // 没有纪录则添加
    [array insertObject:item atIndex:0];
    [self saveCacheArray:array withKey:key];
}

// 遍历Cache数组
+ (void)ergodicCacheWithKey:(NSString *)key block:(BOOL(^)(NSMutableArray * array, ICComicListItem * i))block
{
    NSMutableArray * array = [self getCacheArrayWithKey:key];
    BOOL needContinue;
    for (ICComicListItem * i in array)
    {
        needContinue = block(array, i);
        if (!needContinue) { break; }
    }
}

+ (BOOL)hasCacheItem:(ICComicListItem *)item withKey:(NSString *)key;
{
    __block BOOL has = NO;
    [self ergodicCacheWithKey:key block:^(NSMutableArray *array, ICComicListItem *i) {
        if ([i.workid isEqualToString:item.workid])
        {
            has = YES;
            return NO;
        }
        return YES;
    }];
    return has;
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
    [self ergodicCacheWithKey:ICComicEpisodeHistoryKey block:^BOOL(NSMutableArray *array, ICComicListItem *i) {
        if ([i.workid isEqualToString:item.workid])
        {
            [array removeObject:i];
            [self saveCacheArray:array withKey:ICComicEpisodeHistoryKey];
            return NO;
        }
        return YES;
    }];
}

+ (void)removeFavorite:(ICComicListItem *)item;   ///< 删除收藏
{
    [self ergodicCacheWithKey:ICComicEpisodeFavoriteKey block:^BOOL(NSMutableArray *array, ICComicListItem *i) {
        if ([i.workid isEqualToString:item.workid])
        {
            [array removeObject:i];
            [self saveCacheArray:array withKey:ICComicEpisodeFavoriteKey];
            return NO;
        }
        return YES;
    }];
}

+ (void)removeAllHistorys;    ///< 删除所有历史
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeHistoryKey];
    [array removeAllObjects];
    [self saveCacheArray:array withKey:ICComicEpisodeHistoryKey];
}

+ (void)removeAllFavorites;   ///< 删除所有收藏
{
    NSMutableArray * array = [self getCacheArrayWithKey:ICComicEpisodeFavoriteKey];
    [array removeAllObjects];
    [self saveCacheArray:array withKey:ICComicEpisodeFavoriteKey];
}

+ (BOOL)hasHistory:(ICComicListItem *)item; ///< 是否有此历史纪录
{
    return [self hasCacheItem:item withKey:ICComicEpisodeHistoryKey];
}
+ (BOOL)hasFavorite:(ICComicListItem *)item; ///< 是否有该收藏纪录
{
    return [self hasCacheItem:item withKey:ICComicEpisodeFavoriteKey];
}

@end
