//
//  ECHttpRequestUrl.m
//  Pods
//
//  Created by 菅帅博 on 2016/11/29.
//
//

#import "ECHttpRequestUrl.h"

@implementation ECHttpRequestUrl

+ (NSString *)connectUrl:(NSMutableDictionary *)params url:(NSString *)baseUrl
{
    // 初始化参数变量
    NSString *str = [[baseUrl substringFromIndex:baseUrl.length - 1] isEqualToString:@"?"] ? @"" : @"?";
    
    // 快速遍历参数数组
    for(id key in params) {
//        NSLog(@"key :%@  value :%@", key, [params objectForKey:key]);
        str = [str stringByAppendingString:key];
        str = [str stringByAppendingString:@"="];
        str = [str stringByAppendingString:[params objectForKey:key] ? [params objectForKey:key] : @""];
        str = [str stringByAppendingString:@"&"];
    }
    // 处理多余的&以及返回含参url
    if (str.length > 1) {
        // 去掉末尾的&
        str = [str substringToIndex:str.length - 1];
        // 返回含参url
        return [baseUrl stringByAppendingString:str];
    }
    return baseUrl;
}

@end
