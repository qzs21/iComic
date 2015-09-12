//
//  ICComicDetail.h
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICBaseModel.h"
#import "ICComicImage.h"
#import "ICComicEpisode.h"

@interface ICComicDetail : ICBaseModel

//@property (nonatomic, strong) BOOL newflag;         ///< 未知？
//@property (nonatomic, strong) NSString * scflag;    ///< 未知？
//@property (nonatomic, assign) BOOL complete;        ///< 是否已完结 n,y

@property (nonatomic, strong) ICComicImage * image; ///< 预览图
@property (nonatomic, assign) BOOL free;            ///< 是否免费
@property (nonatomic, strong) NSString * genre;     ///< 分类名
@property (nonatomic, strong) NSString * genreid;   ///< 分类ID
@property (nonatomic, strong) NSDate * lastupdate;  ///< 最后更新时间
@property (nonatomic, strong) NSDate * update;      ///< 更新时间
@property (nonatomic, strong) NSString * painter;   ///< 绘图作者
@property (nonatomic, strong) NSString * painterid; ///< 绘图作者ID
@property (nonatomic, strong) NSString * writer;    ///< 剧情作者
@property (nonatomic, strong) NSString * writerid;  ///< 剧情作者ID
@property (nonatomic, assign) NSInteger recommend;  ///< 推荐数
@property (nonatomic, assign) float score;          ///< 评分
@property (nonatomic, strong) NSString * summary;   ///< 简介
@property (nonatomic, assign) NSInteger tag;        ///< 标签数量
@property (nonatomic, strong) NSString * title;     ///< 标题
@property (nonatomic, strong) NSArray <ICComicEpisode> * volume;     ///< 剧集集合
@property (nonatomic, assign) NSInteger volumecount;///< 章节总数
@property (nonatomic, strong) NSString * week;      ///< 星期几（名字）
@property (nonatomic, assign) NSInteger weekid;     ///< 星期几（代码）
@property (nonatomic, assign) NSString * workid;    ///< 漫画ID
@end
