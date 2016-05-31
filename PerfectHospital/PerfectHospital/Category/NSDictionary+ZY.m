//
//  NSDictionary+ZYLog.m
//  weibo
//
//  Created by on 15/7/29.
//  Copyright (c) 2015年 ZY. All rights reserved.
//


#import "NSDictionary+ZY.h"
//字典和数组里的数据Unicode 转为 汉字的方法
@implementation NSDictionary (ZY)
- (NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"{\n"];
//  遍历数组的所有元素
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n",key,obj];
    }];
    [str appendString:@"}"];
//   查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        [str deleteCharactersInRange:range];
    }
    return str;
}
@end

@implementation NSArray (ZY)

- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    //    遍历数组中所有元素
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
              [str appendFormat:@"%@,\n",obj];
        }];
    [str appendString:@"]"];
    //   查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
          [str deleteCharactersInRange:range];
    }
    return str;
}

@end
