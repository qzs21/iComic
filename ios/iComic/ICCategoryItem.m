//
//  ICCategoryItem.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICCategoryItem.h"

@implementation ICCategoryItem

- (ICSubCategoryItem *)currentSelectedSubCategoryItem
{
    // 防止越界
    if (self.subCategoryItemsIndex >= self.subCategoryItems.count)
    {
        return nil;
    }
    return self.subCategoryItems[self.subCategoryItemsIndex];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


@end
