//
//  ECHttpRequestCache.m
//  ECHttpRequestManager
//
//  Created by Microseer on 16/9/14.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import "ECHttpRequestCache.h"
#import "YYCache.h"

@implementation ECHttpRequestCache

static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static YYCache *_dataCache;


+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

+ (void)saveResponseCache:(id)responseCache forKey:(NSString *)key
{
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:responseCache forKey:key withBlock:nil];
}

+ (id)getResponseCacheForKey:(NSString *)key
{
    return [_dataCache objectForKey:key];
}

@end
