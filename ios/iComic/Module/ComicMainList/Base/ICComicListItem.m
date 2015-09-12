//
//  ICComicListItem.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICComicListItem.h"

@implementation ICComicListItem

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"cover.url": @"thumbnailURL",
                                                       @"volumecount": @"chaptersTotal",
                                                       @"workid": @"ID",
                                                       }];
}

@end
