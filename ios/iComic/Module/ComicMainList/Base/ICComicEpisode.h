//
//  ICComicEpisode.h
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ICComicImage.h"

@protocol ICComicEpisode <NSObject> @end

/// 漫画剧集
@interface ICComicEpisode : JSONModel

@property (nonatomic, strong) NSString * image;         ///< 缩略图
@property (nonatomic, strong) NSDate * data;            ///< 更新时间
@property (nonatomic, assign) NSInteger score;          ///< 评分
@property (nonatomic, strong) NSString * title;         ///< 本集标题
@property (nonatomic, strong) NSString * volumeid;      ///< 本集ID
@property (nonatomic, strong) NSString * workid;        ///< 漫画ID

@end
