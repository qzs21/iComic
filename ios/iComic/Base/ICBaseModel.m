//
//  ICBaseModel.m
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICBaseModel.h"
#import "ICBaseViewController.h"

@implementation ICBaseModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation JSONValueTransformer (CustomTransformer)
- (NSDate *)NSDateFromNSString:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:ICAPIDateFormat];
    return [formatter dateFromString:string];
}
- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:ICAPIDateFormat];
    return [formatter stringFromDate:date];
}
@end
