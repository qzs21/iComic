//
//  NetworkDataCenter.h
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <Foundation/Foundation.h>


/// iPhone 固定参数
#define NetworkDataCenterIPhoneParams @["dtype": @"i"]

/// API 路径
#define NetworkDataCenterAPIBasePath @"http://182.254.180.202/gw/v100"


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




// 推荐 连载
// get_works_series.html?dtype=i&cat=s&rows_per_limit=15&page=1
// 推荐 完结
// get_works_finish.html?dtype=i&cat=s&rows_per_limit=15&page=1

// 排行 连载
// get_works_series.html?dtype=i&cat=r&rows_per_limit=15&page=1
// 排行 完结
// get_works_finish.html?dtype=i&cat=r&rows_per_limit=15&page=1


// 完结 推荐
// get_works_recommend.html?dtype=i&rows_per_limit=15&page=1
// 完结 评分
// get_works_score.html?dtype=i&rows_per_limit=15&page=1
// 完结 最新
// get_works_recent.html?dtype=i&cat=c&rows_per_limit=15&page=1

// 题材 （漫画分类，通过分类ID获取）
// genreid 分类id,  rows_per_limit 每页大笑, page 当前页码（从1开始）
// get_works_genre.html?dtype=i&genreid=1017&rows_per_limit=15&page=1

// 星期 最新
// get_works_recent.html?dtype=i&cat=w&rows_per_limit=15&page=1
// 星期 周一 ~ 周日
// weekid 1~7
// get_works_week.html?dtype=i&page=1&rows_per_limit=15&weekid=1












/******************* API ********************/

/// 获取区域
#define NetworkDataCenterAPIRegions     @"get_regions.html"

/// 获取分类
#define NetworkDataCenterAPIGenres      @"get_genres.html"


@interface NetworkDataCenter : NSObject

@end
