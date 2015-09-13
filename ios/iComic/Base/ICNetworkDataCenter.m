//
//  ICNetworkDataCenter.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICNetworkDataCenter.h"

@import AFNetworking;
@import NSObjectExtend;
@import TMCache;

/// API 路径
#define ICAPIBasePath @"http://182.254.180.202/gw/v100"

#define ICAPIKeyPage             @"page"
#define ICAPIKeyLimit            @"rows_per_limit"
#define ICAPIKeyDeviceType       @"dtype"    /// 设备类型
#define ICAPIKeyValueIPhone      @"i"        /// iPhone 固定参数


@implementation ICNetworkDataCenter

+ (void)GET:(NSString *)URL params:(NSDictionary *)params block:(ICNetworkDataCenterBlock)block;
{
    [self GET:URL params:params userCache:YES block:block];
}

+ (void)GET:(NSString *)URL params:(NSDictionary *)params userCache:(BOOL)userCache block:(ICNetworkDataCenterBlock)block
{
    NSString * cacheKey = nil;

    // 如果存在缓存，回调缓存数据
    if (userCache)
    {
        cacheKey = [URL stringByAppendingString:SAVE_STRING(params.description)];
        [[TMCache sharedCache] objectForKey:cacheKey block:^(TMCache *cache, NSString *key, id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (object)
                {
                    NSLog(@"读取缓存cacheKey: %@", cacheKey);
                    if (block) {
                        block(object, YES);
                    }
                }
            });
        }];
    }
    
    static AFHTTPRequestOperationManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        // 使用BasePath初始化请求器
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:ICAPIBasePath]];
        // 设置JSON解析器对文档类型的过滤
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    });
    
    // 添加固定参数
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic setObject:ICAPIKeyValueIPhone forKey:ICAPIKeyDeviceType];
    
    // 发起请求
    [manager GET:URL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 回调成功
        NSLog(@"%@", responseObject);
        
        // 保存缓存
        if (userCache) {
            [[TMCache sharedCache]  setObject:responseObject forKey:cacheKey block:nil];
        }
        
        // 回调
        if (block) {
            block(responseObject, NO);
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO 发送失败通知
        // 回调失败
        
        // 清除缓存
        if (userCache) {
            [[TMCache sharedCache] removeObjectForKey:cacheKey block:nil];
        }
        
        // 回调
        if (block) {
            block(nil, NO);
        }
    }];
}

// 请求分页数据
+ (void)GET:(NSString *)URL page:(NSUInteger)page limit:(NSUInteger)limit block:(ICNetworkDataCenterBlock)block
{
    NSDictionary * param = @{ICAPIKeyPage: IntToString(page),
                             ICAPIKeyLimit: IntToString(limit)};
    [self GET:URL params:param userCache:page==1 block:block];
}

+ (void)GET:(NSString *)URL page:(NSUInteger)page block:(ICNetworkDataCenterBlock)block;
{
    [self GET:URL page:page limit:15 block:block];
}

@end
