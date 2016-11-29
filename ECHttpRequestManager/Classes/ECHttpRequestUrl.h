//
//  ECHttpRequestUrl.h
//  Pods
//
//  Created by 菅帅博 on 2016/11/29.
//
//

#import <Foundation/Foundation.h>

@interface ECHttpRequestUrl : NSObject

+ (NSString *)connectUrl:(NSMutableDictionary *)params url:(NSString *)baseUrl;

@end
