//
//  NSString+CJGUTF8Encoding.m
//  CJGNetworkingDemo
//
//  Created by NQ UEC on 2018/5/21.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "NSString+CJGUTF8Encoding.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC

#endif
@implementation NSString (CJGUTF8Encoding)

+ (NSString *)cjg_stringUTF8Encoding:(NSString *)urlString{
#if TARGET_OS_IPHONE
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0){
        return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else{
        return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
#elif TARGET_OS_MAC
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
}

+ (NSString *)cjg_urlString:(NSString *)urlString appendingParameters:(id)parameters{
    if (parameters==nil) {
        return urlString;
    }else{
        NSString *parametersString;
        if ([parameters isKindOfClass:[NSDictionary class]]){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSString *key in parameters) {
                id obj = [parameters objectForKey:key];
                NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
                [array addObject:str];
            }
            parametersString = [array componentsJoinedByString:@"&"];
        }else{
            parametersString =[NSString stringWithFormat:@"%@",parameters] ;
        }
        return [urlString stringByAppendingString:[NSString stringWithFormat:@"?%@",parametersString]];
    }
}

@end

@implementation CJGRequestTool

+ (id)formaParameters:(id)parameters filtrationCacheKey:(NSArray *)filtrationCacheKey{
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [mutableParameters removeObjectsForKeys:filtrationCacheKey];
        return [mutableParameters copy];
    }else {
        return parameters;
    }
}

@end
