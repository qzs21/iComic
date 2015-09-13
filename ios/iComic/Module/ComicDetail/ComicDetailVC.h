//
//  DetailViewController.h
//  iComic
//
//  Created by 韦烽传 on 15/9/11.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "ICBaseViewController.h"
#import "ICComicDetail.h"
#import "ICComicListItem.h"

@interface ComicDetailVC : ICBaseViewController

@property (nonatomic, strong) ICComicDetail * detail; ///< 漫画详情
@property (nonatomic, strong) ICComicListItem * listItem; ///< 列表中的信息

@end
