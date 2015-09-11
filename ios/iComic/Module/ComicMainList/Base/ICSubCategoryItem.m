//
//  ICSubCategoryItem.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICSubCategoryItem.h"

@interface ICSubCategoryItem()
{
    __strong NSMutableArray * mComicList;
}

@end

@implementation ICSubCategoryItem

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (NSArray *)comicItems
{
    return mComicList;
}

- (void)addComicListArray:(NSArray *)array;
{
    if (mComicList == nil)
    {
        mComicList = [NSMutableArray array];
    }
    [mComicList addObjectsFromArray:array];
}

@end
