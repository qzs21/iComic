//
//  ICNetworkDataCenter.h
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//




// 获取区域列表
// get_regions.html?dtype=i


// 获取app启动信息
// return : init_page 启动页标志，show_excat 显示额外的
// get_app_launch_info.html?dtype=i





// 获取APP启动信息
//
// http://182.254.180.202/gw/v100/get_app_launch_info.html?dtype=i


// 获取漫画详情
// workid 漫画id
// get_work.html?dtype=i&uid=&site=&workid=300185


// 搜索漫画
// search 搜索内容 page 当前页码 rows_per_limit 分页大小
// get_works_search.html?dtype=i&rows_per_limit=15&search=hao&page=1





/******************* 最新 ********************/

/// 最新
#define ICAPINewest      @"get_works_recent.html?cat=w"
/// 周一
#define ICAPIWeek1       @"get_works_week.html?weekid=1"
/// 周一
#define ICAPIWeek2       @"get_works_week.html?weekid=2"
/// 周一
#define ICAPIWeek3       @"get_works_week.html?weekid=3"
/// 周一
#define ICAPIWeek4       @"get_works_week.html?weekid=4"
/// 周一
#define ICAPIWeek5       @"get_works_week.html?weekid=5"
/// 周一
#define ICAPIWeek6       @"get_works_week.html?weekid=6"
/// 周一
#define ICAPIWeek7       @"get_works_week.html?weekid=7"


/******************* 题材（分类） ********************/
// genreid 分类id,  rows_per_limit 每页, page 当前页码（从1开始）
#define ICAPITheme   @"get_works_genre.html"



/******************* 连载 ********************/
// 连载推荐
#define ICAPISerialRecommended   @"get_works_series.html?cat=s"
// 连载排行
#define ICAPISerialRanking       @"get_works_series.html?cat=r"
//// 连载评分
//#define ICAPISerialScore         @"get_works_series.html?cat=7"
//// 连载最新
//#define ICAPISerialNewest        @"get_works_series.html?cat=7"



/******************* 完结 ********************/
// 完结推荐
#define ICAPIFinishRecommended   @"get_works_recommend.html"
// 完结排行
#define ICAPIFinishRanking       @"get_works_finish.html?cat=r"
// 完结评分
#define ICAPIFinishScore         @"get_works_score.html"
// 完结最新
#define ICAPIFinishNewest        @"get_works_recent.html?cat=c"





/// 获取区域
#define ICAPIRegions     @"get_regions.html"

/// 获取分类
#define ICAPIGenres      @"get_genres.html"

@import Foundation;

typedef void(^ICNetworkDataCenterBlock)(id object);

@interface ICNetworkDataCenter : NSObject

// 发起数据请求
+ (void)GET:(NSString *)URL params:(NSDictionary *)params block:(ICNetworkDataCenterBlock)block;

// 获取分页的数据
+ (void)GET:(NSString *)URL page:(NSUInteger)page limit:(NSUInteger)limit block:(ICNetworkDataCenterBlock)block;
+ (void)GET:(NSString *)URL page:(NSUInteger)page block:(ICNetworkDataCenterBlock)block;

@end
