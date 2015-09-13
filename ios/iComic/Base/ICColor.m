//
//  ICColor.m
//  iComic
//
//  Created by Steven on 15/9/13.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICColor.h"

@import NSObjectExtend;
@import BlocksKit;

@implementation ICColor

+ (NSMutableDictionary *)ic_store
{
    __block NSMutableDictionary * ic_stroeDic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ic_stroeDic = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(onUIApplicationDidReceiveMemoryWarningNotification)
         name:UIApplicationDidReceiveMemoryWarningNotification
         object:nil];
    });
    return ic_stroeDic;
}

+ (void)onUIApplicationDidReceiveMemoryWarningNotification
{
    [self.ic_store removeAllObjects];
}

+ (instancetype)ic_colorWithKey:(NSString *)key
{
    NSMutableDictionary * store = [self ic_store];
    id color = store[key];
    if (color == nil) {
        color = [UIColor colorWithHexCode:key];
        [store setObject:color forKey:key];
    }
    return color;
}

/**
 *  主色调
 */
+ (instancetype)ic_tintColor;
{
    return [self ic_colorWithKey:@"007AFF"];
}

/**
 *  背景色
 */
+ (instancetype)ic_backgroundColor;
{
    return [self ic_colorWithKey:@"F0F0F0"];
}

@end
