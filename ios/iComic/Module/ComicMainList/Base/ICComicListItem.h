//
//  ICComicListItem.h
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

@import JSONModel;

@protocol ICComicListItem <NSObject> @end

/// 漫画列表元素
@interface ICComicListItem : JSONModel

/// 漫画ID
@property (nonatomic, strong) NSString * ID;

/// 漫画标题
@property (nonatomic, strong) NSString * title;

/// 漫画缩略图URL
@property (nonatomic, strong) NSString * thumbnailURL;

/// 评分
@property (nonatomic, assign) float score;

/// 章节总数
@property (nonatomic, assign) NSInteger chaptersTotal;

/// 漫画绘图作者
@property (nonatomic, strong) NSString * painter;

/// 剧情文案作者
@property (nonatomic, strong) NSString * writer;

/// 免费
@property (nonatomic, assign) BOOL free;

@end
