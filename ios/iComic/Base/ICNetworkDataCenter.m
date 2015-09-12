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

/// API 路径
#define ICAPIBasePath @"http://182.254.180.202/gw/v100"

#define ICAPIKeyPage             @"page"
#define ICAPIKeyLimit            @"rows_per_limit"
#define ICAPIKeyDeviceType       @"dtype"    /// 设备类型
#define ICAPIKeyValueIPhone      @"i"        /// iPhone 固定参数



@implementation ICNetworkDataCenter

+ (void)GET:(NSString *)URL params:(NSDictionary *)params block:(ICNetworkDataCenterBlock)block
{
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
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO 发送失败通知
        // 回调失败
        block(nil);
    }];
}

// 请求分页数据
+ (void)GET:(NSString *)URL page:(NSUInteger)page limit:(NSUInteger)limit block:(ICNetworkDataCenterBlock)block
{
    NSDictionary * param = @{ICAPIKeyPage: IntToString(page),
                             ICAPIKeyLimit: IntToString(limit)};
    [self GET:URL params:param block:block];
}

+ (void)GET:(NSString *)URL page:(NSUInteger)page block:(ICNetworkDataCenterBlock)block;
{
    [self GET:URL page:page limit:15 block:block];
}

@end
