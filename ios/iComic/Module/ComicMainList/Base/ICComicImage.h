//
//  ICComicImage.h
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICBaseModel.h"

@protocol ICComicImage <NSObject> @end

// 漫画图片信息
@interface ICComicImage : ICBaseModel

@property (nonatomic, assign) float height;     ///< 高度
@property (nonatomic, assign) float  width;     ///< 宽度
@property (nonatomic, assign) NSInteger size;   ///< 文件大小
@property (nonatomic, strong) NSString * type;  ///< 文件类型，（png，jpg）
@property (nonatomic, strong) NSString * url;   ///< 文件链接

@end
