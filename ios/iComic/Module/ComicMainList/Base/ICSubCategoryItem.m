//
//  ICSubCategoryItem.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICSubCategoryItem.h"

@implementation ICSubCategoryItem

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (instancetype)init
{
    if (self = [super init]) {
        _comicItems = (id)[NSMutableArray array];
        _page = 1;
    }
    return self;
}


@end
